import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FCMNotificationServices {
  final String endpoint = "https://fcm.googleapis.com/fcm/send";
  String authorization =
      "key=AAAAlbMnBMI:APA91bEzDYHksiUmHaWbXb-pg8fBJMf7VgQAtvnGq2-3gtrU4BZSgKJRXolRjyOHoy8srCbsjpKzMWRbW-PPFAf2_ko5KKM4teklZVDXxr3FZFKwVOtQpoBA_Q-c3XqpYdxSJnh3Jh-U";
  String contentType = 'application/json';
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<http.Response> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final dynamic data = json.encode(
        {
          "to": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "content_available": true,
        },
      );
      http.Response response = await http.post(
        Uri.parse(endpoint),
        body: data,
        headers: {
          'Content-Type': contentType,
          'Authorization': authorization,
        },
      );
      return response;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> sendNotificationToUser({
    required String token,
    required String title,
    required String body,
  }) {
    return sendNotification(token: token, title: title, body: body);
  }

  Future<void> sendNotificationToGroup({
    required String group,
    required String title,
    required String body,
  }) {
    return sendNotification(token: "/topics/$group", title: title, body: body);
  }

  Future<void> subscribeToTopic({required String topic}) {
    return firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic({required String topic}) {
    return firebaseMessaging.unsubscribeFromTopic(topic);
  }

}
