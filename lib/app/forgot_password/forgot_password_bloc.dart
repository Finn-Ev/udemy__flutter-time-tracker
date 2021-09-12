import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/forgot_password/forgot_password_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ForgotPasswordBloc {
  ForgotPasswordBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<ForgotPasswordModel> _modelController =
      StreamController<ForgotPasswordModel>();

  Stream<ForgotPasswordModel> get modelStream => _modelController.stream;

  ForgotPasswordModel _model =
      ForgotPasswordModel(); // latest value added to the stream

  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updateWith({
    String email,
    bool isLoading,
    bool isSubmitted,
  }) {
    _model = _model.copyWith(
      email: email,
      isLoading: isLoading,
      isSubmitted: isSubmitted,
    );
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      await auth.sendPasswordResetEmail(_model.email);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
