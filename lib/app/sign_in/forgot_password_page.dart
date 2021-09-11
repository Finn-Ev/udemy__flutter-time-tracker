import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: ForgotPasswordForm(),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Reset Password'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
