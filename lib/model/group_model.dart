import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? topic;
  String? groupId;
  String? groupName;
  String? adminId;
  String? lastMessage;
  Timestamp? timeLastMessage;
  String? groupImage;

  GroupModel({
    this.topic,
    this.groupId,
    required this.groupName,
    this.adminId,
    this.groupImage,
    this.lastMessage,
    this.timeLastMessage,
  });

  GroupModel.fromJson(Map<String, dynamic>? json) {
    groupId = json!['groupId'];
    groupName = json['groupName'];
    adminId = json['adminId'];
    groupImage = json['groupImage'];
    topic = json['topic'];
    lastMessage = json['lastMessage'];
    timeLastMessage = json['timeLastMessage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'groupId': groupId,
      'groupName': groupName,
      'groupImage': groupImage,
      'adminId': adminId,
    };
  }
}
