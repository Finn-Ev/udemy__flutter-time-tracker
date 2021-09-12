import 'package:time_tracker_flutter_course/app/util/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isSubmitted = false,
    this.isLoading = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isSubmitted;
  final bool isLoading;

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? 'Need an account? Register '
      : 'Already have an account? Sign in';

  String get passwordErrorText =>
      !emailValidator.isValid(password) && isSubmitted
          ? invalidEmailErrorText
          : null;

  String get emailErrorText => !emailValidator.isValid(email) && isSubmitted
      ? invalidEmailErrorText
      : null;

  bool get isSubmitEnabled =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
