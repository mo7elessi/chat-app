import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? senderId; //المرسل
  String? receiverId; //المستقبل
  String? messageId;
  Timestamp? dateTime;
  String? message;
  List<String>? images;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.dateTime,
    required this.message,
    this.images,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageId = json['messageId'];
    dateTime = json['dateTime'];
    message = json['message'];
    images = json["images"] == null ? [] : List<String>.from(
        json["images"].map((x) => x));
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'dateTime': dateTime,
      'message': message,
      'images': images,
    };
  }
}
