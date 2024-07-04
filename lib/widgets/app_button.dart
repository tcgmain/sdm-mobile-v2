// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class CommonAppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CommonAppButton({super.key, 
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
          side: BorderSide(
            color: CustomColors.buttonBorderColor.withOpacity(0.6),
            width: 1,
          ),
          elevation: 10,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColors.buttonColor1.withOpacity(0.3),
                CustomColors.buttonColor2.withOpacity(0.3),
                CustomColors.buttonColor3.withOpacity(0.3),
                CustomColors.buttonColor4.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
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
    );
  }
}
