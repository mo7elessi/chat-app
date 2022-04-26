import 'package:chat_app/shared/style/colors.dart';
import 'package:flutter/material.dart';

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(0.0),
  borderSide: const BorderSide(width: 0.3, color: Color(0xff979191)),
);

ThemeData theme = ThemeData(
  fontFamily: '',
  scaffoldBackgroundColor: backgroundColor,
  inputDecorationTheme: InputDecorationTheme(
    hoverColor: primaryColor,
    focusColor: primaryColor,
    hintStyle: const TextStyle(fontSize: 14),
    enabledBorder: outlineInputBorder,
    errorBorder: outlineInputBorder,
    focusedErrorBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    prefixStyle: const TextStyle(
      color: primaryColor,
    ),
  ),
  primarySwatch: primaryColor,
  primaryColor: primaryColor,
  textTheme: const TextTheme(

  ));
