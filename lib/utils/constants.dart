// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomColors {

  static const Color appBarColor1 = Color(0xFFec1c24);
  static const Color appBarColor2 = Color(0xFFf02024);
  static const Color appBarTextColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color borderColor = Color(0xFFf02024);
  static const Color formBackgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF84898D);
  static const Color textHighlightColor = Color(0xFFFFCEC663);
  static const Color textHighlightColor1 = Color(0xFFEEEEEE);
  static const Color textColorBlue = Color(0xFF0062A9);
  static const Color textColorGreen = Color(0xFF00AB66);
  static const Color textColorWhite = Color(0xFFFFFFFF);
  static const Color textColorGrey = Color(0xFF707070);
  static const Color headingTextColor = Color(0xFF0062A9);
  static const Color errorTextColor = Color(0xFFFF0000);
  static const Color textFieldFillColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFB2B0B0);
  static const Color buttonColor = Color(0xFF0062A9);
  static const Color buttonColor1 = Color(0xFF0062A9);
  static const Color buttonColor2 = Color(0xFF0062A9);
  static const Color buttonColor3 = Color(0xFF0062A9);
  static const Color buttonColor4 = Color(0xFF0062A9);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color buttonBorderColor = Color(0xFFFFFFFF);
  static const Color checkBoxColor = Color(0xFF0062A9);
  static const Color navigationActiveBackgroundColor = Color(0xFF424242);
  static const Color navigationBackgroundColor = Color(0xFF000000);
  static const Color navigationActiveTextColor = Color(0xFFFFFFFF);
  static const Color navigationTextColor = Color(0xFFFFFFFF);
  
}

getFontSize() {
  var textSize = 16.0;
  return textSize;
}

getFontSizeSmall() {
  var textSize = 14.0;
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
  var formattedDate = DateFormat('yyyy/MM/dd').format(date);
  return formattedDate;
}

getHorizontalTitleGap() {
  double horizontalTitleGap = 5.0;
  return horizontalTitleGap;
}
