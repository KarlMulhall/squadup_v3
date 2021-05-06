import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/auth/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  RegisterCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RegisterState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: RegisterStatus.initial));
    //change the username and then reset the RegisterStatus from error to initial
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: RegisterStatus.initial));
    //change the email and then reset the RegisterStatus from error to initial
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: RegisterStatus.initial));
    //change the password and then reset the RegisterStatus from error to initial
  }

  void signUpWithCredentials() async {
    //if the form is not valid OR the status is already submitting then return
    if (!state.isFormValid || state.status == RegisterStatus.submitting) return;

    emit(state.copyWith(status: RegisterStatus.submitting));

    try {
      await _authRepository.signUpWithEmailAndPassword(
          username: state.username, email: state.email, password: state.password);
      emit(state.copyWith(status: RegisterStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: RegisterStatus.error));
    }
  }
}
