import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SocialSignInButton(
            'Sign in with Google',
            assetName: 'images/google-logo.png',
            textColor: Colors.black87,
            backgroundColor: Colors.white,
            onPressed: () => {},
          ),
          SizedBox(
            height: 10,
          ),
          SocialSignInButton(
            'Sign in with Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            backgroundColor: Color(0xFF334D92),
            onPressed: () => {},
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton(
            'Sign in with email',
            textColor: Colors.white,
            backgroundColor: Colors.teal,
            onPressed: () => {},
          ),
          SizedBox(height: 10),
          Text(
            'or',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton(
            'Go anonymous',
            textColor: Colors.white,
            backgroundColor: Colors.black,
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
