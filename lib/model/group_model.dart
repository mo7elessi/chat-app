import 'package:chat_app/model/message_model.dart';

class GroupModel {
  String? groupId;
  String? groupName;
  String? adminId;
  String? groupImage;
  List<String>? usersInGroup;

  GroupModel({
    this.groupId,
    required this.groupName,
    this.usersInGroup,
    this.adminId,
  });

  GroupModel.fromJson(Map<String, dynamic>? json) {
    groupId = json!['groupId'];
    groupName = json['groupName'];
    adminId = json['adminId'];
    groupImage = json['groupImage'];
    json['usersInGroup'].forEach((element) {
      usersInGroup!.add(element);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'usersInGroup': usersInGroup,
    };
  }
}
