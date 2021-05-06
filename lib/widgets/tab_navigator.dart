import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/config/custom_router.dart';
import 'package:squadup_v3/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:squadup_v3/enums/enums.dart';
import 'package:squadup_v3/repositories/notification/notification_repository.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';
import 'package:squadup_v3/repositories/user/user_repository.dart';
import 'package:squadup_v3/screens/create_post/create_post_screen.dart';
import 'package:squadup_v3/screens/create_post/cubit/create_post_cubit.dart';
import 'package:squadup_v3/screens/home/bloc/home_bloc.dart';
import 'package:squadup_v3/screens/home/home_screen.dart';
import 'package:squadup_v3/screens/notifications/bloc/notifications_bloc.dart';
import 'package:squadup_v3/screens/notifications/notifications_screen.dart';
import 'package:squadup_v3/screens/profile/bloc/profile_bloc.dart';
import 'package:squadup_v3/screens/profile/profile_screen.dart';
import 'package:squadup_v3/screens/search/cubit/search_cubit.dart';
import 'package:squadup_v3/screens/search/search_screen.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavBarItem navBarItem;
  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.navBarItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context)),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {
      tabNavigatorRoot: (context) => _getScreen(context, navBarItem),
    };
  }

  Widget _getScreen(BuildContext context, BottomNavBarItem navBarItem) {
    switch (navBarItem) {
      case BottomNavBarItem.home:
        return BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(
              HomeFetchPosts(),
            ),
          child: HomeScreen(),
        );

      case BottomNavBarItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) =>
              SearchCubit(userRepository: context.read<UserRepository>()),
          child: SearchScreen(),
        );

      case BottomNavBarItem.createPost:
        return BlocProvider(
          create: (context) => CreatePostCubit(
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: CreatePostScreen(),
        );

      // case BottomNavBarItem.createPlayer:
      //   return BlocProvider(
      //     create: (context) => CreatePlayerCubit(
      //       playerRepository: context.read<PlayerRepository>(),
      //       storageRepository: context.read<StorageRepository>(),
      //       authBloc: context.read<AuthBloc>(),
      //     ),
      //     child: CreatePlayerScreen(),
      //   );

      case BottomNavBarItem.notifications:
        return BlocProvider<NotificationsBloc>(
          create: (context) => NotificationsBloc(
            notificationRepository: context.read<NotificationRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: NotificationsScreen(),
        );

      case BottomNavBarItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            playerRepository: context.read<PlayerRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen(),
        );

      // case BottomNavBarItem.messaging:
      //   return BlocProvider(
      //     create: (context) => MessagingCubit(
      //       userRepository: context.read<UserRepository>(),
      //       storageRepository: context.read<StorageRepository>(),
      //       authBloc: context.read<AuthBloc>(),
      //     ),
      //     child: MessagingScreen(),
      //   );

      default:
        return Scaffold();
    }
  }
}
