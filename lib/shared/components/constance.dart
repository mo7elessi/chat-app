import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

String userId = '';
String token = '';

List<Contact> contacts = [];
List<Item> phones = [];

void getContacts() async {
  List<Contact> _contacts =
      await ContactsService.getContacts(withThumbnails: true);
  contacts = _contacts;
  for (var element in contacts) {
    for (var phone in element.phones!) {
      phones.add(phone);
    }
  }
}

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
