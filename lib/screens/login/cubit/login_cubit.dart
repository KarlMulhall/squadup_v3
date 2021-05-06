import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:squadup_v3/models/failure_model.dart';
import 'package:squadup_v3/repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepo;
  LoginCubit({@required AuthRepository authRepository})
      : _authRepo = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
    //change the email and then reset the LoginStatus from error to initial
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
    //change the email and then reset the LoginStatus from error to initial
  }

  void logInWithCredentials() async {
    //if the form is not valid OR the status is already submitting then return
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;

    emit(state.copyWith(status: LoginStatus.submitting));

    try {
      await _authRepo.logInWithEmailAndPassword(
          email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
