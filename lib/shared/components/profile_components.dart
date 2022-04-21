
import 'package:chat_app/shared/components/main_components.dart';
import 'package:flutter/material.dart';

Widget userData({
  required IconData icon,
  required String text,
  required String data,
  required String textButton,
}) {
  return Row(
      children: [
        Icon(icon, color: Colors.grey),
        spaceBetween(vertical: false, size: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            spaceBetween(size: 10),
            Text(
              data,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: Text(textButton)),
      ],
  );
}

