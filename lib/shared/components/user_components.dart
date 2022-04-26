import 'package:chat_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shared_components.dart';

AppBar userAppBar() {
  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0.0,
    title: logo(),
    automaticallyImplyLeading: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
    ),
  );
}