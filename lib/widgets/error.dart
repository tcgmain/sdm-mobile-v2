// ignore_for_file: use_super_parameters

import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetryPressed;

  const Error({key, this.errorMessage, required this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.buttonColor,
              minimumSize: const Size(50, 50),
            ),
            onPressed: onRetryPressed,
            child: const Text('Retry', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}
