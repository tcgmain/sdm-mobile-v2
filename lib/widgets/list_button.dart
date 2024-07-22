import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class ListButton extends StatelessWidget {
  final String displayName;
  final String? rightPosition;
  final bool? isLeftAlign;
  final VoidCallback onPressed;

  const ListButton({
    Key? key,
    required this.displayName,
    this.rightPosition,
    this.isLeftAlign,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.black,
                    Colors.black26,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: isLeftAlign == true ? Alignment.centerLeft: Alignment.center,
                  child: TextButton(
                    onPressed: onPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      textStyle: TextStyle(fontSize: getFontSize()),
                    ),
                    child: Text(displayName),
                  ),
                ),
              ),
              if (rightPosition != null)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: CustomColors.textColorGrey,
                      padding: const EdgeInsets.all(15),
                      textStyle: TextStyle(fontSize: getFontSize()),
                    ),
                    child: Text(rightPosition!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
