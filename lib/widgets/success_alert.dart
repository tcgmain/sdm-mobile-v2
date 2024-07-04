import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

showSuccessAlertDialog(BuildContext context, successMessage) {
  Widget okButton = TextButton(
      child: const Text("OK", style: TextStyle(color: CustomColors.buttonColor)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(false);
        });
      });
  AlertDialog alert = AlertDialog(
    title: const Text("Success!"),
    content: Text(successMessage),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
