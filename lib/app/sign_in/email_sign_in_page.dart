import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: EmailSignInForm(),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
