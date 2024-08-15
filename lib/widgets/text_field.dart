// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:sdm/utils/constants.dart';
import 'package:sdm/utils/validations.dart';
import 'package:flutter/material.dart';

class TextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscureText;
  final String inputType; //Input Types = {none, email, password}
  final bool isRequired;
  final function;
  final VoidCallback onChangedFunction;
  final fillColor;
  final FocusNode? myFocusNode;
  final bool? filled;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? autoFocus;

  const TextField(
      {required this.controller,
      this.obscureText,
      required this.inputType,
      required this.isRequired,
      this.function,
      required this.onChangedFunction,
      this.fillColor,
      this.myFocusNode,
      this.filled,
      this.labelText,
      this.suffixIcon,
      this.autoFocus});

  @override
  Widget build(BuildContext context) {
    
      final focusNode = myFocusNode ?? FocusNode();

    return TextFormField(
      style: const TextStyle(color: CustomColors.textFieldTextColor, fontWeight: FontWeight.bold),
      onChanged: (value) {
        onChangedFunction();
      },
      controller: controller,
      obscureText: obscureText!,
      focusNode: focusNode ,
      autofocus: autoFocus == true ? true : false,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          filled: filled,
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.textFieldBorderColor, width: 2.0),
            borderRadius: BorderRadius.circular(50.0),
          ),
          labelStyle: TextStyle(
              color: focusNode .hasFocus ? CustomColors.textFieldTextColor : CustomColors.textFieldTextColor)),

      // ignore: missing_return
      validator: (v) {
        //Required
        if (isRequired == true) {
          if (inputType == 'none') {
            if (v!.isEmpty) {
              return "required";
            } else {
              return null;
            }
          } else if (inputType == 'email') {
            if (v!.isEmpty) {
              return "Required";
            } else if (!v.isValidEmail) {
              return "Invalid";
            } else {
              return null;
            }
          } else if (inputType == 'password') {
            if (v!.isEmpty) {
              return "Required";
            } else if (!v.isValidPassword) {
              return "Invalid";
            } else {
              return null;
            }
          }
        }
        //Not required
        else {
          if (inputType == 'none') {
            return null;
          } else if (inputType == 'email') {
            if (v!.isValidEmail) {
              return "Invalid";
            } else {
              return null;
            }
          } else if (inputType == 'password') {
            if (v!.isValidPassword) {
              return "Invalid";
            } else {
              return null;
            }
          }
        }
        return null;
      },
    );
  }
}

Widget getPasswordSuffixIcon(function, obscureText) {
  return GestureDetector(
    onTap: function,
    child: obscureText
        ? const Icon(
            Icons.visibility,
            color: CustomColors.buttonColor,
          )
        : const Icon(Icons.visibility_off, color: CustomColors.textColor),
  );
}
