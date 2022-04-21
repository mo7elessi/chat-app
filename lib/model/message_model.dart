import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? senderId; //المرسل
  String? receiverId;//المستقبل
  String? messageId;
  Timestamp? dateTime;
  String? message;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.dateTime,
    required this.message,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageId = json['messageId'];
    dateTime = json['dateTime'];
    message = json['message'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'dateTime': dateTime,
      'message': message,
    };
  }
}
