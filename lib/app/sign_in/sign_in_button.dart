import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton(
    String text, {
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
    double borderRadius = 4,
  }) : super(
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
              ),
            ),
            onPressed: onPressed,
            textColor: textColor,
            height: 45);
}
