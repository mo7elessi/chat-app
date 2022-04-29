import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';

class GroupModel {
  String? groupId;
  String? groupName;
  String? adminId;
  String? groupImage;
 // UserModel usersInGroup;
 // List<MessageModel>? messageModel;

  GroupModel({
    this.groupId,
    required this.groupName,
    this.adminId,
    this.groupImage,
   // this.usersInGroup,
  //  this.messageModel,
  });

  GroupModel.fromJson(Map<String, dynamic>? json) {
    groupId = json!['groupId'];
    groupName = json['groupName'];
    adminId = json['adminId'];
    groupImage = json['groupImage'];
    // json['usersInGroup'].forEach((element) {
    //   usersInGroup!.add(element);
    // });
    // json['messageModel'].forEach((element) {
    //   messageModel!.add(element);
    // });
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
     // 'usersInGroup': usersInGroup,
     // 'messageModel': messageModel,
      'groupImage': groupImage,
      'adminId': adminId,
    };
  }
}
