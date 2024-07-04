// ignore_for_file: use_key_in_widget_constructors

import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  final String? text;

  const FormLabel({@required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.0,
      child: Text(
        text.toString(),
        style: const TextStyle(fontSize: 16.0, color: CustomColors.textColor),
      ),
    );
  }
}
