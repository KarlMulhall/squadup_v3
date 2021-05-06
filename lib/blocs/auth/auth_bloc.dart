import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:squadup_v3/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;

  // Listens to any changes in the user that is currently logged in to
  // firebase.
  StreamSubscription<auth.User> _userSub;

  AuthBloc({
    @required AuthRepository authRepository,
  })  : _authRepo = authRepository,
        // AuthState is set to unknown when first instantiated as it is unknown
        // what the current state of the user is yet
        super(AuthState.unknown()) {
    _userSub =
        _authRepo.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }

  // Stream that constantly listens for any change to the Auth Event
  //
  // it then maps this Event change to the State of the Bloc
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // calls different methods based on the current event
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      print('User Logged out');
      await _authRepo.logOut();
    }
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    print('User Changed!');

    // if the users event is not equal to null
    //     the state is set to authenticated
    // else
    //     state is set to unauthenticated
    yield event.user != null
        ? AuthState.authenticated(user: event.user)
        : AuthState.unauthenticated();
  }
}
