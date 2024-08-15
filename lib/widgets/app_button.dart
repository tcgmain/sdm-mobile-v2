// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class CommonAppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CommonAppButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(
            color: CustomColors.buttonBorderColor,
            width: 1,
          ),
          elevation: 10,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                CustomColors.buttonColor3,
                CustomColors.buttonColor2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: TextStyle(
                color: CustomColors.buttonTextColor,
                fontSize: getFontSize(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
