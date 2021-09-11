import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/forgot_password_page.dart';
import 'package:time_tracker_flutter_course/app/util/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      // await Future.delayed(Duration(seconds: 3));

      switch (_formType) {
        case EmailSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(_email, _password);
          break;
        case EmailSignInFormType.register:
          await auth.createUserWithEmailAndPassword(_email, _password);
          break;
        // case EmailSignInFormType.forgotPassword:
        //   await auth.sendPasswordResetEmail(_email);
        //   break;
      }

      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } on PlatformException catch (e) {
      showAlertDialog(
        context,
        title: 'Sign in failed',
        content: e.message,
        defaultActionText: 'OK',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _forgotPassword(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';

    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register '
        : 'Already have an account? Sign in';

    TextField _buildEmailTextField() {
      bool showErrorText = !widget.emailValidator.isValid(_email) && _submitted;
      return TextField(
        controller: _emailController,
        autocorrect: false,
        enabled: !_isLoading,
        decoration: InputDecoration(
            labelText: 'Email',
            errorText: showErrorText ? widget.invalidEmailErrorText : null),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => setState(() {}),
        textInputAction: TextInputAction.next,
      );
    }

    Widget _buildPasswordTextField(bool submitEnabled) {
      bool showErrorText =
          !widget.emailValidator.isValid(_password) && _submitted;

      return TextField(
        controller: _passwordController,
        decoration: InputDecoration(
            enabled: !_isLoading,
            labelText: 'Password',
            errorText: showErrorText ? widget.invalidPasswordErrorText : null),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: (value) => setState(() {}),
        onEditingComplete: submitEnabled ? _submit : null,
      );
    }

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      _buildPasswordTextField(submitEnabled),
      SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
      TextButton(
        onPressed: !_isLoading ? () => _forgotPassword(context) : null,
        child: Text('Forgot password?'),
      ),
      if (_isLoading) LinearProgressIndicator(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
