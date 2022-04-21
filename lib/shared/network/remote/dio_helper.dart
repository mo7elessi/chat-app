import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postNotification({
    required Map<String, dynamic> data,
    String? token,
  }) async {
    String key =
        "key=AAAAlbMnBMI:APA91bEzDYHksiUmHaWbXb-pg8fBJMf7VgQAtvnGq2-3gtrU4BZSgKJRXolRjyOHoy8srCbsjpKzMWRbW-PPFAf2_ko5KKM4teklZVDXxr3FZFKwVOtQpoBA_Q-c3XqpYdxSJnh3Jh-U";
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };
    return dio!.post("", data: data);
  }
}
