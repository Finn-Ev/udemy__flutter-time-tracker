import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/util/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

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

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      // await Future.delayed(Duration(seconds: 3));
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on Exception catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
  }

  _rebuildWidget() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';

    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
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
        onChanged: (value) => _rebuildWidget(),
        textInputAction: TextInputAction.next,
      );
    }

    TextField _buildPasswordTextField(bool submitEnabled) {
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
        onChanged: (value) => _rebuildWidget(),
        onEditingComplete: submitEnabled ? _submit : null,
      );
    }

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      // _isLoading ? LinearProgressIndicator() : Container(),
      _buildEmailTextField(),
      _buildPasswordTextField(submitEnabled),
      SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
        style: ElevatedButton.styleFrom(),
      ),
      _isLoading ? LinearProgressIndicator() : Container(),
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
