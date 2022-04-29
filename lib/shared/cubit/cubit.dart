import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:chat_app/shared/network/remote/dio_helper.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:chat_app/views/onlineUsers/online_users_page.dart';
import 'package:chat_app/views/profile/profile_page.dart';
import 'package:chat_app/views/users/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(AppInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<Widget> pages = const [];
  List<Widget> buildPages = [
    const HomePage(),
    const UsersPage(),
    const OnlineUsersPage(),
    const ProfilePage(),
  ];

  int currentIndex = 0;

  List<String> appBarTitle = ['Chats', 'Users', 'Online User', 'Profile'];

  List<BottomNavigationBarItem> navBarsItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.message),
      label: "Chats",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: "Users",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.online_prediction),
      label: "Online",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.contacts_rounded),
      label: "Profile",
    ),
  ];

  void onClickItemNavigation(int index) {
    currentIndex = index;
    emit(BottomNavigationState());
  }

  //list of UserModel to add all users
  List<UserModel> users = [];
  List<UserModel> allUsers = [];

  //object from UserModel
  UserModel? user;

  //get current user data func
  void getUserData() {
    emit(GetUserDataLoading());
    store.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      user = UserModel.fromJson(value.data());
      emit(GetUserDataSuccess());
    }).catchError(
      (onError) {
        emit(GetUserDataError());
      },
    );
  }

  //send message func
  void sendMessage({
    required String receiverId,
    required String message,
    required String messageId,
  }) {
    emit(SendMessageLoading());
    MessageModel model = MessageModel(
      message: message,
      senderId: user!.id,
      messageId: messageId,
      receiverId: receiverId,
      dateTime: Timestamp.now(),
    );
    //to store message in chat sender
    store
        .collection('users')
        .doc(user!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError());
    });
    //to store message in chat receiver
    store
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(user!.id)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccess());
    }).catchError((error) {
      emit(SendMessageError());
    });
  }

  List<MessageModel> messages = [];

  //get messages func
  void getMessages({
    required String receiverId,
  }) {
    emit(GetMessagesLoading());
    store
        .collection('users')
        .doc(user!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen(
      (event) {
        messages = [];
        for (var element in event.docs) {
          messages.add(MessageModel.fromJson(element.data()));
        }
        emit(GetMessagesSuccess());
      },
    );
  }

  //delete chat func
  void deleteChat({required String receiverId}) async {
    var doc = await store
        .collection('users')
        .doc(user!.id)
        .collection('chats')
        .doc(receiverId)
        .collection("messages")
        .get();
    for (var element in doc.docs) {
      element.reference.delete();
    }
  }

  //delete message for me or for all user (sender, receiver) func
  void deleteMessage({
    required String receiverId,
    required String messageId,
    String? status,
  }) async {
    var doc = await store
        .collection('users')
        .doc(user!.id)
        .collection('chats')
        .doc(receiverId)
        .collection("messages")
        .where("messageId", isEqualTo: messageId)
        .get();
    doc.docs[0].reference.delete();

    if (status == "deleteForAll") {
      var doc = await store
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(user!.id)
          .collection("messages")
          .limit(1)
          .where("messageId", isEqualTo: messageId)
          .get();
      doc.docs[0].reference.delete();
    }
    emit(DeleteMessageSuccess());
  }

  //create group func
  void createGroup({
    required String groupName,
  }) {
    String groupId = const Uuid().v4();
    GroupModel groupModel = GroupModel(
      groupName: groupName,
      groupId: groupId,
      adminId: user!.id,
      groupImage: user!.image,
    );
    store.collection('groups').doc(groupId).set(groupModel.toMap());
  }

  //send message func
  void sendMessageToGroup({
    required String receiverId,
    required String message,
    required String messageId,
  }) {
    MessageModel model = MessageModel(
      message: message,
      senderId: user!.id,
      messageId: messageId,
      receiverId: receiverId,
      dateTime: Timestamp.now(),
    );
    //to store message in chat sender
    store
        .collection('groups')
        .doc(receiverId)
        .collection("messages")
        .add((model.toMap()));
    //to store message in chat receiver
    store
        .collection('groups')
        .doc(receiverId)
        .collection("messages")
        .add((model.toMap()));
  }

  // update group func [add new user > 'John', 'Yasmeen']
  void setNewUserInGroup({
    required String groupId,
    bool status = true,
    required String userId,
  }) {
    Map<String, dynamic> user() {
      return {
        'id': userId,
        'status': status,
      };
    }
    store.collection('groups').doc(groupId).collection("users").add(user());
  }

  List<String> usersInGroup = [];

  void getUsersInGroup({required String groupId}) {
    store
        .collection('groups')
        .doc(groupId)
        .collection("users")
        .get()
        .then((value) {
      for (var element in value.docs) {
        userInGroup.add(element.data()['id']);
      }
      if (kDebugMode) {
        print("HZM ${value.docs.first.data()['id']}");
      }
    });
  }

  void deleteUserFromGroup({required String groupId, required String userId}) {
    store
        .collection('groups')
        .doc(groupId)
        .collection("users")
        .where("id", isEqualTo: userId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
  }

  GroupModel? groups;

  void getGroups() {
    store.collection('groups').get().then((value) {
      for (var element in value.docs) {
        groups = GroupModel.fromJson(element.data());
      }
      emit(GetGroupsSuccessState());
    }).catchError((onError) {
      emit(GetGroupsErrorState(onError.toString()));
    });
  }

  List<String> userInGroup = [];

  void setStatusUser({required bool userActive}) {
    store
        .collection("users")
        .doc(userId)
        .update({"userActive": userActive}).then((value) {});
  }

// list to add user active
  List<String> listUserActive = [];
  List<UserModel> usersActiveModel = [];

  List<Contact> contacts = [];

// get user active func
  void getActiveUsers() async {
    emit(GetOnlineUsersLoading());
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: true);
    contacts = _contacts;
    store
        .collection("users")
        .where("userActive", isEqualTo: true)
        .snapshots()
        .listen((event) {
      listUserActive = [];
      usersActiveModel = [];
      for (var element in event.docs) {
        for (var contact in contacts) {
          for (var phone in contact.phones!) {
            if (phone.value == element.data()['phone'] &&
                listUserActive.contains(element.id) == false) {
              usersActiveModel.add(UserModel.fromJson(element.data()));
              listUserActive.add(element.id);
            }
          }
        }
      }
      emit(GetActiveUsersSuccess());
    });
  }

  void getUsers() async {
    emit(GetUsersLoading());
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: true);
    contacts = _contacts;
    store.collection('users').get().then((value) {
      for (var element in value.docs) {
        store
            .collection('users')
            .doc(user!.id)
            .collection('chats')
            .doc(element.data()['id'])
            .collection('messages')
            .orderBy('dateTime', descending: true)
            .snapshots()
            .listen(
          (event) {
            for (var contact in contacts) {
              for (var phone in contact.phones!) {
                UserModel userModel = UserModel(
                  token: element.data()['token'],
                  id: element.data()['id'],
                  username: element.data()['username'],
                  phone: element.data()['phone'],
                  image: element.data()['image'],
                  lastMessage: event.docs.first.data()["message"],
                  timeLastMessage: event.docs.first.data()["dateTime"],
                );
                if (phone.value == element.data()['phone']) {
                  allUsers.add(userModel);
                  if (event.docs.first.data()["message"].isNotEmpty) {
                    users.add(userModel);
                  }
                }
              }
            }
          },
        );
      }
      emit(GetUsersSuccess());
    }).catchError((onError) {
      if (kDebugMode) {
        print("HZM ${onError.toString()}");
      }
      emit(GetUsersError(onError.toString()));
    });
  }

  String readTimestamp(int? timestamp) {
    if (timestamp != null) {
      var now = DateTime.now();
      var format = DateFormat('hh:mm a');
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var diff = now.difference(date);
      var time = '';
      if (diff.inSeconds <= 0 ||
          diff.inSeconds > 0 && diff.inMinutes == 0 ||
          diff.inMinutes > 0 && diff.inHours == 0 ||
          diff.inHours > 0 && diff.inDays == 0) {
        time = format.format(date);
      } else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = diff.inDays.toString() + ' DAY ${format.format(date)}';
        } else {
          time = diff.inDays.toString() + ' DAYS ${format.format(date)}';
        }
      } else {
        if (diff.inDays == 7) {
          time = (diff.inDays / 7).floor().toString() +
              ' WEEK ${format.format(date)}';
        } else {
          time = (diff.inDays / 7).floor().toString() +
              ' WEEKS ${format.format(date)}';
        }
      }
      return time;
    }
    return "";
  }
}

String getInitials({required String text}) {
  List<String> names = text.split(" ");
  String initials = "";
  int numWords = 2;

  if (numWords < names.length) {
    numWords = names.length;
  }
  for (var i = 0; i < numWords; i++) {
    initials += names[i][0];
  }
  return initials;
}

// enum ToastStates { SUCCESS, ERROR, WARNING }
//
// Color chooseToastColor(ToastStates state) {
//   Color color;
//
//   switch (state) {
//     case ToastStates.SUCCESS:
//       color = Colors.green;
//       break;
//     case ToastStates.ERROR:
//       color = Colors.red;
//       break;
//     case ToastStates.WARNING:
//       color = Colors.amber;
//       break;
//   }
//
//   return color;
// }
