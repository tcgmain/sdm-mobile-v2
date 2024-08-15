import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

Future<void> showSuccessAlertDialog(BuildContext context, String successMessage, VoidCallback onClose) {
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(
        color: CustomColors.successAlertTitleTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    ),
    onPressed: () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(false);
        onClose();
      });
    },
  );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(color: CustomColors.successAlertBorderColor),
    ),
    backgroundColor: CustomColors.successAlertBackgroundColor,
    elevation: 24.0,
    titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
    contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
    actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8.0, 8.0),
    title: const Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: CustomColors.successAlertTitleTextColor,
          size: 30.0,
        ),
        SizedBox(width: 10.0),
        Text(
          "Success",
          style: TextStyle(
            color: CustomColors.successAlertTitleTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ],
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

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return alert;
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ).drive(Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        )),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}



Future<void> showSuccessAlertDialogWithBack(BuildContext context, String successMessage) {
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(
        color: CustomColors.successAlertTitleTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    ),
    onPressed: () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      });
    },
  );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(color: CustomColors.successAlertBorderColor),
    ),
    backgroundColor: CustomColors.successAlertBackgroundColor,
    elevation: 24.0,
    titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
    contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
    actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8.0, 8.0),
    title: const Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: CustomColors.successAlertTitleTextColor,
          size: 30.0,
        ),
        SizedBox(width: 10.0),
        Text(
          "Success",
          style: TextStyle(
            color: CustomColors.successAlertTitleTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ],
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

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return alert;
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ).drive(Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        )),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
