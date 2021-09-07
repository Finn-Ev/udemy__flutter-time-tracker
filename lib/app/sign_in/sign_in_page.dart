import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.onSignIn, @required this.auth})
      : super(key: key);

  final AuthBase auth;

  final void Function(User) onSignIn;

  Future<void> _signInAnonymously() async {
    try {
      final user = await auth.signInAnonymously();
      onSignIn(user);
    } catch (e) {
      print(e.toString());
    }
  }

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
            onPressed: () => _signInAnonymously(),
          ),
        ],
      ),
    );
  }
}
