import 'dart:ffi';

import 'package:care_management/const/colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final String buttonText;

  const CustomElevatedButton(
      {super.key, required this.onButtonPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(32.0)),
        child: SizedBox(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ));
  }
}
