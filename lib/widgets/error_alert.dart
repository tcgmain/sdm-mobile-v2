import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

void showErrorAlertDialog(BuildContext context, String errorMessage) {
  Widget okButton = TextButton(
    child: const Text("OK", style: TextStyle(color: CustomColors.errorAlertTitleTextColor, fontWeight: FontWeight.bold)),
    onPressed: () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(false);
      });
    },
  );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(color: CustomColors.errorAlertBorderColor)
    ),
    
    backgroundColor: CustomColors.errorAlertBackgroundColor,
    elevation: 24.0,
    title: const Text(
      "Error!",
      style: TextStyle(
        color: CustomColors.errorAlertTitleTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    ),
    content: Text(
      errorMessage,
      style: const TextStyle(
        color: CustomColors.errorAlertTextColor,
        fontSize: 18.0,
      ),
    ),
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
