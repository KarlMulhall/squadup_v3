import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:squadup_v3/models/failure_model.dart';
import 'base_auth_repository.dart';
import 'package:meta/meta.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  AuthRepository({
    FirebaseFirestore firebaseFirestore,
    auth.FirebaseAuth firebaseAuth,
    // FirebaseMessaging messaging,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;
        // _messaging = messaging ?? FirebaseMessaging.instance;


  // Stream to listen to any changes to the current firebase user logged in
  @override
  Stream<auth.User> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User> signUpWithEmailAndPassword(
      {@required String username,
      @required String email,
      @required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      String token = await _messaging.getToken();
      _firebaseFirestore.collection(DbPaths.users).doc(user.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
        'token': token,
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<auth.User> logInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
