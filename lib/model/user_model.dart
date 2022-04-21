import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? token;
  String? username;
  String? email;
  String? phone;
  String? bio;
  String? image;
  bool? isEmailVerified = true;
  String? lastMessage;
  Timestamp? timeLastMessage;
  bool? userActive;

  UserModel({
    required this.token,
    this.id,
    required this.username,
    this.email,
    this.isEmailVerified,
    this.phone,
    this.bio,
    this.image,
    this.userActive,
    this.lastMessage,
    this.timeLastMessage,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    bio = json['bio'];
    image = json['image'];
    isEmailVerified = json['isEmailVerified'];
    userActive = json['userActive'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'phone': phone,
      'bio': bio,
      'image': image,
      'userActive': userActive,
    };
  }
}
