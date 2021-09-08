import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: EmailSignInForm(
              auth: auth,
            ),
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
