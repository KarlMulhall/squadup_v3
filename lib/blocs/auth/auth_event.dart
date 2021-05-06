part of 'auth_bloc.dart';

// Declares the different events that can be passed from the UI to the Bloc

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}

// called when firebase updates the user that is currently signed in
class AuthUserChanged extends AuthEvent {
  final auth.User user;

  const AuthUserChanged({@required this.user});

  @override
  List<Object> get props => [user];
}

// called when the user tries to log out
class AuthLogoutRequested extends AuthEvent {}