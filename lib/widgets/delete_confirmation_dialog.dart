// ignore_for_file: prefer_const_constructors

import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

showConfirmationDialog(BuildContext context, String itemCode, VoidCallback callback) {
  Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: CustomColors.buttonColor)),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(false);
        });
      });
  Widget deleteButton = TextButton(onPressed: callback, child: Text("Delete", style: TextStyle(color: CustomColors.buttonColor)));
  AlertDialog alert = AlertDialog(
    title: Text("Delete"),
    content: Text('Are you sure you want to delete this item: $itemCode?'),
    actions: [cancelButton, deleteButton],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
