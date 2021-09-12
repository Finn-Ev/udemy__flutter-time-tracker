import 'package:time_tracker_flutter_course/app/util/validators.dart';

class ForgotPasswordModel with EmailAndPasswordValidators {
  ForgotPasswordModel({
    this.email = '',
    this.isSubmitted = false,
    this.isLoading = false,
  });

  final String email;
  final bool isSubmitted;
  final bool isLoading;

  String get emailErrorText => !emailValidator.isValid(email) && isSubmitted
      ? invalidEmailErrorText
      : null;

  bool get isSubmitEnabled => emailValidator.isValid(email) && !isLoading;

  ForgotPasswordModel copyWith({
    String email,
    bool isLoading,
    bool isSubmitted,
  }) {
    return ForgotPasswordModel(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
