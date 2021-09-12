import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/forgot_password/forgot_password_page.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.model});

  final EmailSignInModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<EmailSignInModel>(
      create: (_) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (_, model, __) => EmailSignInForm(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailSignInModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _forgotPassword(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  List<Widget> _buildChildren() {
    TextField _buildEmailTextField() {
      return TextField(
        controller: _emailController,
        autocorrect: false,
        enabled: !model.isLoading,
        decoration: InputDecoration(
          labelText: 'Email',
          errorText: model.emailErrorText,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: model.updateEmail,
        textInputAction: TextInputAction.next,
      );
    }

    Widget _buildPasswordTextField() {
      return TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          enabled: !model.isLoading,
          labelText: 'Password',
          errorText: model.passwordErrorText,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: model.updatePassword,
        onEditingComplete: model.isSubmitEnabled ? _submit : null,
      );
    }

    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        model.primaryButtonText,
        onPressed: model.isSubmitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        onPressed: !model.isLoading ? model.toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
      TextButton(
        onPressed: !model.isLoading ? () => _forgotPassword(context) : null,
        child: Text('Forgot password?'),
      ),
      if (model.isLoading) LinearProgressIndicator(),
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
