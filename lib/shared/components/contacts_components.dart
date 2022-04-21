import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

List<Contact> contacts = [];

Future<Widget> buildContactItem() async {
  List<Contact> _contacts = await ContactsService.getContacts();
  contacts = _contacts;
  return ListView.builder(
    itemCount: contacts.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return Expanded(
        child: Container(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              contacts[index].avatar != null &&
                  contacts[index].avatar!.isNotEmpty
                  ? CircleAvatar(
                  maxRadius: 30,
                  backgroundImage: MemoryImage(contacts[index].avatar!))
                  : CircleAvatar(
                  maxRadius: 30, child: Text(contacts[index].initials())),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    contacts[index].displayName.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff383838),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

