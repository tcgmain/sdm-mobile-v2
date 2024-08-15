import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

Future<void> showConfirmationDialog(BuildContext context, Function onConfirm, String message, String title) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button
    builder: (BuildContext context) {
      return AlertDialog(
         shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(color: CustomColors.errorAlertBorderColor),
    ),
    backgroundColor: CustomColors.errorAlertBackgroundColor,
    elevation: 24.0,
    titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
    contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
    actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8.0, 8.0),
        title: Row(
      children: [
        const Icon(
          Icons.help_outline,
          color: CustomColors.errorAlertTitleTextColor,
          size: 30.0,
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: const TextStyle(
            color: CustomColors.errorAlertTitleTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ],
    ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
      message,
      style: const TextStyle(
        color: CustomColors.errorAlertTextColor,
        fontSize: 18.0,
      ),
    ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No', style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes', style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}
