import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:squadup_v3/screens/home/bloc/home_bloc.dart';
import 'package:squadup_v3/widgets/center_text.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';
import 'package:squadup_v3/widgets/post_view.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/feed';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<HomeBloc>().state.status != HomeStatus.paginating) {
          context.read<HomeBloc>().add(HomePaginatePosts());
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        } else if (state.status == HomeStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Fetching Posts..'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SquadUp'),
            actions: [
              if (state.posts.isEmpty && state.status == HomeStatus.loaded)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      context.read<HomeBloc>().add(HomeFetchPosts()),
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(HomeState state) {
    if (state.posts.isEmpty && state.status == HomeStatus.loaded) {
      return Scaffold(
        body: CenterText(
          text: 'No posts to display...',
        ),
      );
    }
    switch (state.status) {
      case HomeStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeFetchPosts());
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = state.posts[index];
              final likedPostsState = context.watch<LikedPostsCubit>().state;
              var isLiked = likedPostsState.likedPostIds.contains(post.id);
              final recentlyLiked =
                  likedPostsState.recentlyLikedPostIds.contains(post.id);
              return PostView(
                post: post,
                isLiked: isLiked,
                recentlyLiked: recentlyLiked,
                onLike: () {
                  if (isLiked == true) {
                    context.read<LikedPostsCubit>().unlikePost(post: post);
                    isLiked = false;
                    setState(() {
                      
                    });
                  } else {
                    context.read<LikedPostsCubit>().likePost(post: post);
                    isLiked = true;
                    setState(() {
                      
                    });
                  }
                },
              );
            },
          ),
        );
    }
  }
}
