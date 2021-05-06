import 'package:flutter/material.dart';
import 'package:squadup_v3/screens/comments/comments_screen.dart';
import 'package:squadup_v3/screens/create_player/create_player_screen.dart';
import 'package:squadup_v3/screens/edit_player/edit_player_screen.dart';
import 'package:squadup_v3/screens/edit_profile/edit_profile_screen.dart';
import 'package:squadup_v3/screens/login/login_screen.dart';
import 'package:squadup_v3/screens/nav/nav_screen.dart';
import 'package:squadup_v3/screens/profile/profile_screen.dart';
import 'package:squadup_v3/screens/register/signup_screen.dart';
import 'package:squadup_v3/screens/splash/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case RegisterScreen.routeName:
        return RegisterScreen.route();
      default:
        return _errorRoute();
    }
  }

  // Generate Nested routes, which are routes only accessible from within other
  // routes. When a nested route is popped from the stack, it returns to the
  // route which it came from.
  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
      case CreatePlayerScreen.routeName:
        return CreatePlayerScreen.route(args: settings.arguments);
      case EditPlayerScreen.routeName:
        return EditPlayerScreen.route(args: settings.arguments);
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(args: settings.arguments);
      case CommentsScreen.routeName:
        return CommentsScreen.route(args: settings.arguments);
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);
      // case MessagingScreen.routeName:
      //   return MessagingScreen.route(args: settings.arguments);
      default:
        return _errorRoute();
    }
  }

  // if there is an error loading the route, displays a screen to inform
  // the user that there has been an error
  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
