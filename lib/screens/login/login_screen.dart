import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/repositories/auth/auth_repository.dart';
import 'package:squadup_v3/screens/login/cubit/login_cubit.dart';
import 'package:squadup_v3/screens/register/signup_screen.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      // Paints over the splash screen instantly
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
          create: (_) =>
              LoginCubit(authRepository: context.read<AuthRepository>()),
          child: LoginScreen()),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, //Prevents user from pressing back button
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.indigo[100],
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Welcome to',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'SquadUp!',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              cursorColor: Colors.indigo,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please enter a valid email'
                                  : null,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be at least 6 characters'
                                  : null,
                            ),
                            const SizedBox(height: 30.0),
                            RaisedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == LoginStatus.submitting),
                              elevation: 1.0,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: const Text('Log In'),
                            ),
                            const SizedBox(height: 12.0),
                            RaisedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName),
                              elevation: 1.0,
                              color: Colors.grey[200],
                              textColor: Theme.of(context).primaryColor,
                              child: const Text('Not Registered? Sign Up Now!'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
