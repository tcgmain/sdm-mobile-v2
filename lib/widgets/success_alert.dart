import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

Future<void> showSuccessAlertDialog(BuildContext context, successMessage) {
  Widget okButton = TextButton(
      child: const Text("OK",
          style: TextStyle(color: CustomColors.successAlertTitleTextColor, fontWeight: FontWeight.bold)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(false);
        });
      });
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: CustomColors.successAlertBorderColor)),
    backgroundColor: CustomColors.successAlertBackgroundColor,
    elevation: 24.0,
    title: const Text(
      "Success!",
      style: TextStyle(
        color: CustomColors.successAlertTitleTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    ),
    content: Text(
      successMessage,
      style: const TextStyle(
        color: CustomColors.successAlertTextColor,
        fontSize: 18.0,
      ),
    ),
    actions: [
      okButton,
    ],
  );
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
