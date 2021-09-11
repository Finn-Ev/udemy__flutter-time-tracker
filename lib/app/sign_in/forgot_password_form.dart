import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/util/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ForgotPasswordForm extends StatefulWidget
    with EmailAndPasswordValidators {
  ForgotPasswordForm({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  bool _submitted = false;
  bool _isLoading = false;

  String get _email => _emailController.text;

  void _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      await auth.sendPasswordResetEmail(_email);

      showAlertDialog(
        context,
        title: 'Success',
        content:
            'An email with instructions to reset your account has been sent',
        defaultActionText: 'Ok',
      ).whenComplete(() => Navigator.of(context).pop());
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'There was an error',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.emailValidator.isValid(_email) && !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        'Reset Password',
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        onPressed: !_isLoading ? () => Navigator.of(context).pop() : null,
        child: Text('Back to sign in'),
      ),
      if (_isLoading) LinearProgressIndicator(),
    ];
  }

  TextField _buildEmailTextField() {
    bool submitEnabled = widget.emailValidator.isValid(_email) && !_isLoading;
    bool showErrorText = !widget.emailValidator.isValid(_email) && _submitted;
    return TextField(
      controller: _emailController,
      autocorrect: false,
      enabled: !_isLoading,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: submitEnabled ? _submit : null,
      onChanged: (value) => setState(() {}),
    );
  }
}
