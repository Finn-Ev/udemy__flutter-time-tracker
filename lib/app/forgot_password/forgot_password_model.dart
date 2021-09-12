import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/util/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ForgotPasswordModel with EmailAndPasswordValidators, ChangeNotifier {
  ForgotPasswordModel({
    @required this.auth,
    this.email = '',
    this.isSubmitted = false,
    this.isLoading = false,
  });

  final AuthBase auth;

  String email;
  bool isSubmitted;
  bool isLoading;

  String get emailErrorText => !emailValidator.isValid(email) && isSubmitted
      ? invalidEmailErrorText
      : null;

  bool get isSubmitEnabled => emailValidator.isValid(email) && !isLoading;

  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      await auth.sendPasswordResetEmail(email);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updateWith({
    String email,
    bool isLoading,
    bool isSubmitted,
  }) {
    this.email = email ?? this.email;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }
}
