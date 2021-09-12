import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model =
      EmailSignInModel(); // latest value added to the stream

  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
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
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      isSubmitted: isSubmitted,
    );
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      switch (_model.formType) {
        case EmailSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(
            _model.email,
            _model.password,
          );
          break;
        case EmailSignInFormType.register:
          await auth.createUserWithEmailAndPassword(
            _model.email,
            _model.password,
          );
          break;
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
