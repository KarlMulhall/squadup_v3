part of 'register_cubit.dart';

enum RegisterStatus { initial, submitting, success, error }

class RegisterState extends Equatable {
  final String username;
  final String email;
  final String password;
  final RegisterStatus status;
  final Failure failure;

  bool get isFormValid => 
      username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  const RegisterState({
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.status,
    @required this.failure,
  });

  factory RegisterState.initial() {
    return RegisterState(
      username: '',
      email: '',
      password: '',
      status: RegisterStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [username, email, password, status, failure];

// copyWith allows changing of other values without
// accidentally setting the others as null.

  RegisterState copyWith({
    String username,
    String email,
    String password,
    RegisterStatus status,
    Failure failure,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
