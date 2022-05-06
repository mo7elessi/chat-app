import 'package:flutter/material.dart';

class UsersInGroupPage extends StatelessWidget {

  const UsersInGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(""),
                maxRadius: 20,
              ),
              title: Text("Username"),
            );
          },
        ),
      ),
    );
  }
}
