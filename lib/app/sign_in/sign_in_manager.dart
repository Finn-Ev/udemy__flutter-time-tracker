import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  // named manager instead of model because it doesnt use/need the ChangeNotifierMixin
  SignInManager({@required this.auth, @required this.isLoading});

  final ValueNotifier<bool> isLoading;

  final AuthBase auth;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    } // no finally block needed because when sign in succeeds, the sign-in-page gets disposed
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

  Future<User> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);

  Future<User> signInWithApple() async => await _signIn(auth.signInWithApple);
}
