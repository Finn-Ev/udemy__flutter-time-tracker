import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signinWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(
          auth: auth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
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
            onPressed: _signInWithGoogle,
          ),
          SizedBox(
            height: 10,
          ),
          SocialSignInButton(
            'Sign in with Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            backgroundColor: Color(0xFF334D92),
            onPressed: _signInWithFacebook,
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton('Sign in with email',
              textColor: Colors.white,
              backgroundColor: Colors.teal,
              onPressed: () => signinWithEmail(context)),
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
