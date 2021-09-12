import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/util/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isSubmitted = false,
    this.isLoading = false,
  });

  final AuthBase auth;

  String email;
  String password;
  EmailSignInFormType formType;
  bool isSubmitted;
  bool isLoading;

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? 'Need an account? Register '
      : 'Already have an account? Sign in';

  String get passwordErrorText =>
      !emailValidator.isValid(password) && isSubmitted
          ? invalidEmailErrorText
          : null;

  String get emailErrorText => !emailValidator.isValid(email) && isSubmitted
      ? invalidEmailErrorText
      : null;

  bool get isSubmitEnabled =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      switch (formType) {
        case EmailSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case EmailSignInFormType.register:
          await auth.createUserWithEmailAndPassword(email, password);
          break;
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    updateWith(formType: formType);
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }
}
