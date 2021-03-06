import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:squadup_v3/repositories/user/user_repository.dart';
import 'package:squadup_v3/screens/comments/comments_screen.dart';
import 'package:squadup_v3/screens/edit_player/edit_player_screen.dart';
import 'package:squadup_v3/screens/profile/bloc/profile_bloc.dart';
import 'package:squadup_v3/screens/profile/widgets/widgets.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';
import 'package:squadup_v3/widgets/player_view.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';

class ProfileScreenArgs {
  final String userId;

  const ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          playerRepository: context.read<PlayerRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostsCubit: context.read<LikedPostsCubit>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            centerTitle: true,
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.logout),
                  color: Color(0xFF1DE9B6),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LikedPostsCubit>().clearAllLikedPosts();
                  },
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(
                  ProfileLoadUser(userId: state.user.id),
                );
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
                      child: Row(
                        children: [
                          UserProfileImage(
                            radius: 50.0,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          ProfileStats(
                            isCurrentUser: state.isCurrentUser,
                            isFollowing: state.isFollowing,
                            posts: state.posts.length,
                            followers: state.user.followers,
                            following: state.user.following,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: ProfileUserInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                      ),
                    ),
                    Divider(
                      color: Colors.tealAccent[400],
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.indigo[300],
                  unselectedLabelColor: Color(0xFF1DE9B6),
                  tabs: [
                    Tab(icon: Icon(Icons.image_outlined, size: 28.0)),
                    Tab(icon: Icon(Icons.person, size: 28.0)),
                  ],
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.indigo[300],
                  onTap: (i) => context
                      .read<ProfileBloc>()
                      .add(ProfileToggleGridView(isGridView: i == 0)),
                ),
              ),

      // Checks whether "isGridView" = true then displays different slivers
      // based on the result.
              state.isGridView
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              CommentsScreen.routeName,
                              arguments: CommentsScreenArgs(
                                post: post,
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: post.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final player = state.players[index];
                          return GestureDetector(
                            onTap: () => state.isCurrentUser
                                ? Navigator.of(context).pushNamed(
                                    EditPlayerScreen.routeName,
                                    arguments: EditPlayerScreenArgs(
                                      player: state.players[index],
                                      context: context,
                                    ),
                                  )
                                : null,
                            child: PlayerView(
                              player: player,
                            ),
                          );
                        },
                        childCount: state.players.length,
                      ),
                    ),
            ],
          ),
        );
    }
  }
}
