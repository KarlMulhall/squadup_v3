part of 'auth_bloc.dart';

// Declare the different states that the Auth Bloc can be set to
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User user;
  final AuthStatus status;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
  });

  // Factories for returning different states to the Bloc. The Bloc
  // will then do something based on the state it is set to.

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({@required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  @override
  bool get stringify => true;

  // props allows us to quickly check whether two properties of two different
  // instances of the object are equal to eachother
  @override
  List<Object> get props => [user, status];
}
