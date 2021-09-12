import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/forgot_password/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: ForgotPasswordForm.create(context),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Forgot Password'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
