import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class CustomIconButton extends StatelessWidget {
  final String tooltip;
  final Icon icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: CustomColors.buttonColor1,
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                CustomColors.buttonColor3,
                CustomColors.buttonColor2,
              ],
               begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        child: IconButton(
          splashColor: CustomColors.buttonColor2,
          highlightColor: CustomColors.buttonColor2,
          hoverColor: CustomColors.buttonColor2,
          focusColor: CustomColors.buttonColor2,
          color: CustomColors.buttonTextColor,
          icon: icon,
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
