import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      dispose: (_, bloc) => bloc.dispose(),
      create: (_) => SignInBloc(auth: auth),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 50,
          ),
          SocialSignInButton(
            'Sign in with Google',
            assetName: 'images/google-logo.png',
            textColor: Colors.black87,
            backgroundColor: Colors.white,
            onPressed: !isLoading ? () => _signInWithGoogle(context) : () {},
          ),
          SizedBox(
            height: 10,
          ),
          SocialSignInButton(
            'Sign in with Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            backgroundColor: Color(0xFF334D92),
            onPressed: !isLoading ? () => _signInWithFacebook(context) : () {},
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton(
            'Sign in with email',
            textColor: Colors.white,
            backgroundColor: Colors.teal,
            onPressed: !isLoading ? () => _signInWithEmail(context) : () {},
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
            onPressed: !isLoading ? () => _signInAnonymously(context) : () {},
          ),
          SizedBox(
            height: 10,
          ),
          isLoading
              ? SizedBox(child: LinearProgressIndicator(), height: 5)
              : SizedBox(height: 5), // placeholer
        ],
      ),
    );
  }
}
