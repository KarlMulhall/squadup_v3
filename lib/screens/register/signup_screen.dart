import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/repositories/auth/auth_repository.dart';
import 'package:squadup_v3/screens/register/cubit/register_cubit.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      // Paints over the splash screen instantly
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<RegisterCubit>(
          create: (_) =>
              RegisterCubit(authRepository: context.read<AuthRepository>()),
          child: RegisterScreen()),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, //Prevents user from pressing back button
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state.status == RegisterStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
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
                    color: Colors.white,
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
                              'SquadUp',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Username'),
                              onChanged: (value) => context
                                  .read<RegisterCubit>()
                                  .usernameChanged(value),
                              validator: (value) => value.trim().isEmpty
                                  ? 'Please enter a valid username'
                                  : null,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<RegisterCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please enter a valid email'
                                  : null,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<RegisterCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be at least 6 characters'
                                  : null,
                            ),
                            const SizedBox(height: 30.0),
                            RaisedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == RegisterStatus.submitting),
                              elevation: 1.0,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: const Text('Sign Up'),
                            ),
                            const SizedBox(height: 12.0),
                            RaisedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              elevation: 1.0,
                              color: Colors.grey[200],
                              textColor: Theme.of(context).primaryColor,
                              child: const Text('Already Signed up? Log in!'),
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
      context.read<RegisterCubit>().signUpWithCredentials();
    }
  }
}
