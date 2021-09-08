import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton(String text, {@required VoidCallback onPressed})
      : super(
            child: Text(text),
            textColor: Colors.white,
            backgroundColor: Colors.blue,
            height: 44,
            onPressed: onPressed);
}
