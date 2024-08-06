// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomColors {
  static const Color appNameTextColor = Color(0xFF707070);
  static const Color appBarColor1 = Color(0xFFec1c24);
  static const Color appBarColor2 = Color(0xFFff4b50);
  static const Color appBarColor3 = Color(0xFFb0161b);
  static const Color appBarTextColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color borderColor = Color(0xFFf02024);
  static const Color borderColor1 = Color(0xFFf0e020);
  static const Color formBackgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFFEEEEEE);
  static const Color textColor2 = Color(0xFFB2B0B0);
  static const Color textHighlightColor = Color(0xFFFFCEC663);
  static const Color textHighlightColor1 = Color(0xFFEEEEEE);
  static const Color textColorBlue = Color(0xFF0062A9);
  static const Color textColorGreen = Color(0xFF00AB66);
  static const Color textColorWhite = Color(0xFFFFFFFF);
  static const Color textColorGrey = Color(0xFF707070);
  static const Color headingTextColor = Color(0xFF0062A9);
  static const Color errorAlertTextColor = Color(0xFFF2F2F2);
  static const Color errorAlertTitleTextColor = Color(0xFFFF0000);
  static const Color errorAlertBorderColor = Color(0xFFFFFFFF);
  static const Color errorAlertBackgroundColor = Color(0xFF000000);

  static const Color successAlertTextColor = Color(0xFFF2F2F2);
  static const Color successAlertTitleTextColor = Color(0xFF00AB66);
  static const Color successAlertBorderColor = Color(0xFFFFFFFF);
  static const Color successAlertBackgroundColor = Color(0xFF000000);

  static const Color textFieldFillColor = Color(0xFFFFFFFF);
  static const Color textFieldBorderColor = Color(0xFFec1c24);
  static const Color textFieldTextColor = Color(0xFF666666);
  static const Color dividerColor = Color(0xFFB2B0B0);
  static const Color buttonColor = Color(0xFFec1c24);
  static const Color buttonColor1 = Color(0xFFec1c24);
  static const Color buttonColor2 = Color(0xFFff4b50);
  static const Color buttonColor3 = Color(0xFFb0161b);
  static const Color buttonColor4 = Color(0xFFf02024);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color buttonBorderColor = Color(0xFFf02024);
  static const Color checkBoxColor = Color(0xFFFFFFFF);
  static const Color navigationActiveBackgroundColor = Color(0xFF424242);
  static const Color navigationBackgroundColor = Color(0xFF000000);
  static const Color navigationActiveTextColor = Color(0xFFFFFFFF);
  static const Color navigationTextColor = Color(0xFFFFFFFF);
  static const Color calenderBackgroundColor1 = Color(0xFFFFFFFF);
  static const Color calenderBackgroundColor2 = Color(0xFFB2B0B0);
  static const Color calenderBackgroundColor3 = Color(0xFF000000);
  static const Color calenderTextColor = Color(0xff3b3b3b);
  static const Color calenderTitleTextColor = Color(0xFFb0161b);
  static const Color loadingColor = Color(0xFFec1c24);

  static const Color cardBoldTextColor = Color(0xff3b3b3b);
  static const Color cardTextColor = Color(0xff141414);
  static const Color cardTextColor1 = Color(0xff3b3b3b);
  static const Color cardBackgroundColor1 = Color(0xff3b3b3b);
  static const Color cardBackgroundColor2 = Color(0xff3b3b3b);
  static const Color cardBackgroundColor3 = Color(0xff141414);
  static const Color cardTextUnderlined = Color(0xff3b3b3b);

  static const Color tableBackgroundColor1 = Color(0xFFB2B0B0);
  static const Color tableBackgroundColor2 = Color(0xFFFFFFFF);
  static const Color tableTextColor = Color(0xff3b3b3b);
}

getFontSize() {
  var textSize = 16.0;
  return textSize;
}

getFontSizeSmall() {
  var textSize = 12.0;
  return textSize;
}

getFontSizeExtraSmall() {
  var textSize = 10.0;
  return textSize;
}

getFontSizeLarge() {
  var headerTextSize = 20.0;
  return headerTextSize;
}

getFontSizeExtraLarge() {
  var textSize = 22.0;
  return textSize;
}

getAppBarTextSize() {
  var textSize = 20.0;
  return textSize;
}

getDateFormat(date) {
  var formattedDate = DateFormat('dd/MM/yyyy').format(date);
  return formattedDate;
}

getCurrentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('dd/MM/yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

getCurrentTime() {
  var now = DateTime.now();
  var formatterTime = DateFormat('kk:mm');
  String time = formatterTime.format(now);
  return time;
}

getHorizontalTitleGap() {
  double horizontalTitleGap = 5.0;
  return horizontalTitleGap;
}

Color getColor(String colorText) {
  switch (colorText) {
    case 'RED':
      return Colors.red;
    case 'GREEN':
      return Colors.green;
    case 'ORANGE':
      return Colors.orange;
    case 'BLUE':
      return Colors.blue;
    case 'YELLOW':
      return Colors.yellow;
    default:
      return Colors.grey; // Default color if the value is unknown
  }
}

getOrganizationColor(organizationType) {
  switch (organizationType) {
    case 'Dealer':
      return "YELLOW";
    case 'Direct Dealer':
      return "ORANGE";
    case 'Distributor':
      return "BLUE";
    case 'Project':
      return "GREEN";
    default:
      return "GREY";
  }
}

getBottomNavigationBarMargin() {
  double bottomNavigationBarMargin = 37.0;
  return bottomNavigationBarMargin;
}

getBottomNavigationBarPadding() {
  double bottomNavigationBarMargin = 20.0;
  return bottomNavigationBarMargin;
}

Future<void> openGoogleMaps(double latitude, double longitude) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  print(url);
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    print('Could not launch $url');
    throw 'Could not launch $url';
  }
}

bool isDataViewer(String userDesignationNummer) {
  switch (userDesignationNummer) {
    case '2346': //Innovation Manager
      return true;
    case '4713': //Sales coordinator
      return true;
    case '4958': //IT manager
      return true;
    case '4959': //Executive Sales Administration
      return true;
    default:
      return false;
  }
}
