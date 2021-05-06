import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/user_data.dart';
import 'package:squadup_v3/screens/login/login_screen.dart';
import 'package:squadup_v3/screens/nav/nav_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Prevents user from pressing back button
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // sends the user to the login screen if there is no current
          // user logged in to firebase
          if (state.status == AuthStatus.unauthenticated) {
            //Go to Login Screen
            Navigator.of(context).pushNamed(LoginScreen.routeName);
            Provider.of<UserData>(context, listen: false).currentUserId =
                state.user.uid;
          }
          // sends the user to the nav screen if the user is logged in to
          // firebase
          else if (state.status == AuthStatus.authenticated) {
            //Go to NAV Screen
            Navigator.of(context).pushNamed(NavScreen.routeName);
            Provider.of<UserData>(context, listen: false).currentUserId =
                state.user.uid;
          }
        },
        child: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
