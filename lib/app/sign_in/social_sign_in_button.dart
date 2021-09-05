import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton(
    String text, {
    @required String assetName,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
    double borderRadius = 4,
  })  : assert(assetName != null),
        super(
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          onPressed: onPressed,
          textColor: textColor,
          height: 45,
        );
}
