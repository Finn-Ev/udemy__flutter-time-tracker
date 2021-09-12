import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/forgot_password/forgot_password_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ForgotPasswordForm extends StatefulWidget {
  ForgotPasswordForm({@required this.model});

  final ForgotPasswordModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<ForgotPasswordModel>(
      create: (_) => ForgotPasswordModel(auth: auth),
      child: Consumer<ForgotPasswordModel>(
        builder: (_, model, __) => ForgotPasswordForm(model: model),
      ),
    );
  }

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordModel get model => widget.model;

  void _submit() async {
    try {
      await model.submit();
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
    }
  }

  List<Widget> _buildChildren(ForgotPasswordModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        'Reset Password',
        onPressed: model.isSubmitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        onPressed: !model.isLoading ? () => Navigator.of(context).pop() : null,
        child: Text('Back to sign in'),
      ),
      if (model.isLoading) LinearProgressIndicator(),
    ];
  }

  TextField _buildEmailTextField(ForgotPasswordModel model) {
    return TextField(
      controller: _emailController,
      autocorrect: false,
      enabled: !model.isLoading,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: model.emailErrorText,
      ),
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: model.isSubmitEnabled ? _submit : null,
      onChanged: model.updateEmail,
    );
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(model),
      ),
    );
  }
}
