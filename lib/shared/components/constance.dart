
import 'package:flutter/material.dart';

String userId = '';
String token = '';

Future<dynamic> navigatorTo(
    {required BuildContext context, required Widget page}) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

Future<dynamic> navigatorAndFinished(
    {required BuildContext context, required Widget page}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
        (route) {
      return false;
    },
  );
}
