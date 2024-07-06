import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class ListButton extends StatelessWidget {
  final String displayName;
  final VoidCallback onPressed;

  const ListButton({
    Key? key,
    required this.displayName,
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
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
              textStyle: TextStyle(fontSize: getFontSize()),
            ),
            child: Text(displayName),
          ),
        ],
      ),
    );
  }
}
