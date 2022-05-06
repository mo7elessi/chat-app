import 'dart:io';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:chat_app/views/onlineUsers/online_users_page.dart';
import 'package:chat_app/views/profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../views/group/groups.dart';
import '../components/constance.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(AppInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String? currentPage;

  List<Widget> pages = const [];
  List<Widget> buildPages = [
    const HomePage(),
    const GroupsPage(),
    const OnlineUsersPage(),
    const ProfilePage(),
  ];

  int currentIndex = 0;

  List<String> appBarTitle = ['Chats', 'Groups', 'Online User', 'Profile'];

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

  void changeState(int index, bool value) {
    emit(Checked());
    allUsers[index].isChecked = value;
  }

  bool isBottomSheetShown = false;

  void changeBottomSheetState({
    required bool isShow,
  }) {
    isBottomSheetShown = isShow;

    emit(AppChangeBottomSheetState());
  }

  void onClickItemNavigation(int index) {
    currentIndex = index;
    emit(BottomNavigationState());
  }

  //list of UserModel to add all users
  List<UserModel> users = [];
  List<UserModel> allUsers = [];

  //object from UserModel
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final ImagePicker pickImage = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final pickedFile = await pickImage.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      fileImage = File(pickedFile.path);
      emit(PickImageSuccessState());
    } else {
      if (kDebugMode) {
        print("error via pick image from gallery");
      }
      emit(PickImageErrorState());
    }
  }

  final ImagePicker pickMultiImage = ImagePicker();
  List<XFile> imageFileList = [];

//pick multi image from gallery func
  void pickMultiImageFromGallery() async {
    final List<XFile>? selectedImages = await pickMultiImage.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
      emit(PickImageSuccessState());
    }

    if (kDebugMode) {
      print("Image List Length:" + imageFileList.length.toString());
    }
    emit(PickImageErrorState());
  }

  List<String> imageUrl = [];
  bool sendImages = false;

//upload multi image to fire storage func
  void uploadMultiImage({
    required String receiverId,
    required String messageId,
    String? message,
  }) {
    emit(UploadMultiImageLoading());
    for (XFile element in imageFileList) {
      File file = File(element.path);
      storage
          .ref()
          .child(
              'chats/$currentUserId/${Uri.file(file.path).pathSegments.last}')
          .putFile(file)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          imageUrl.add(value);
          if (imageUrl.length == imageFileList.length) {
            sendImages = true;
            clearImages();
            sendMessage(
              message: message ?? "New image",
              messageId: messageId,
              receiverId: receiverId,
              images: imageUrl,
            );
          }
        });
        emit(UploadMultiImageSuccess());
      }).catchError((onError) {
        emit(UploadMultiImageError(onError));
      });
    }
  }

  //clear images
  void clearImages() {
    imageFileList = [];
    emit(ClearImagesSuccess());
  }

  //clear image by index
  void clearImageByIndex({required XFile file}) {
    imageFileList.remove(file);
    emit(ClearImagesSuccess());
  }

  int count = 0;

  //send message to user func
  void sendMessage({
    required String receiverId,
    String? message,
    required String messageId,
    List<String>? images,
  }) {
    emit(SendMessageLoading());

    MessageModel model = MessageModel(
      message: message,
      senderId: currentUserId,
      messageId: messageId,
      receiverId: receiverId,
      dateTime: Timestamp.now(),
      images: images,
    );
    //to store message in chat sender
    store
        .collection('users')
        .doc(currentUserId)
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
        .doc(currentUserId)
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
        .doc(currentUserId)
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
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .collection("messages")
        .get();
    for (var element in doc.docs) {
      element.reference.delete();
    }
    isBottomSheetShown = false;
  }

  //delete message for me or for all user (sender, receiver) func
  void deleteMessage({
    required String receiverId,
    required String messageId,
    String? status,
  }) async {
    var doc = await store
        .collection('users')
        .doc(currentUserId)
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
          .doc(currentUserId)
          .collection("messages")
          .limit(1)
          .where("messageId", isEqualTo: messageId)
          .get();
      doc.docs[0].reference.delete();
    }
    isBottomSheetShown = false;

    emit(DeleteMessageSuccess());
  }

  //delete message for me or for all user (sender, receiver) func
  void deleteMessageFromGroup({
    required String groupId,
    required String messageId,
    String? status,
  }) async {
    var doc = await store
        .collection('groups')
        .doc(groupId)
        .collection("messages")
        .where("messageId", isEqualTo: messageId)
        .get();
    doc.docs[0].reference.delete();

    if (status == "deleteForAll") {
      var doc = await store
          .collection('groups')
          .doc(currentUserId)
          .collection("messages")
          .limit(1)
          .where("messageId", isEqualTo: messageId)
          .get();
      doc.docs[0].reference.delete();
    }
    isBottomSheetShown = false;
    emit(DeleteMessageSuccess());
  }

  File? fileImage;

  String uploadImage() {
    late String val;
    storage
        .ref()
        .child('users/${Uri.file(fileImage!.path).pathSegments.last}')
        .putFile(fileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        val = value;
      });
    });
    return val;
  }

  //create group func
  void createGroup({
    required String groupName,
    required String groupId,
  }) {
    emit(CreateGroupLoading());
    storage
        .ref()
        .child('groups/${Uri.file(fileImage!.path).pathSegments.last}')
        .putFile(fileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(UploadImageLoading());
        GroupModel groupModel = GroupModel(
          groupName: groupName,
          groupId: groupId,
          adminId: currentUserId,
          groupImage: value,
        );
        store
            .collection('groups')
            .doc(groupId)
            .set(groupModel.toMap())
            .then((value) {
          emit(CreateGroupSuccess());
        });
      }).catchError((onError) {
        emit(UploadImageError());
      });
    }).catchError((onError) {
      emit(UploadImageError());
    });
  }

  //send message func
  void sendMessageToGroup({
    required String receiverId,
    required String message,
    required String messageId,
  }) {
    MessageModel model = MessageModel(
      message: message,
      senderId: currentUserId,
      messageId: messageId,
      receiverId: receiverId,
      dateTime: Timestamp.now(),
    );
    //to store message in group
    store
        .collection('groups')
        .doc(receiverId)
        .collection("messages")
        .add((model.toMap()))
        .then((value) {
      print("value $value");
    }).catchError((onError) {
      print("onError $onError");
    });
  }

  List<MessageModel> groupMessages = [];

  void getMessagesFromGroup({
    required String groupId,
  }) {
    emit(GetMessagesLoading());
    store
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen(
      (event) {
        groupMessages = [];
        for (var element in event.docs) {
          groupMessages.add(MessageModel.fromJson(element.data()));
        }
        emit(GetMessagesSuccess());
      },
    ).onError((handleError) {
      emit(GetMessagesError());
    });
  }

  // update group func [add new user > 'John', 'Yasmeen']
  void setNewUserInGroup({
    required String groupId,
    required String userId,
  }) {
    Map<String, dynamic> user() {
      return {
        'id': userId,
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

  List<GroupModel> listOfGroups = [];
  List<MessageModel> listOfMessagesInGroups = [];

  GroupModel? groups;

  void getGroups() {
    emit(GetGroupsLoadingState());
    store.collection('groups').snapshots().listen((value) {
      emit(GetGroupsLoadingState());
      listOfGroups = [];
      for (var element in value.docs) {
        store
            .collection('groups')
            .doc(element.data()['groupId'])
            .collection('messages')
            .orderBy('dateTime', descending: true)
            .snapshots()
            .listen((event) {
          groupMessages = [];
          GroupModel groupModel = GroupModel.fromJson(element.data())
            ..lastMessage =
                event.docs.isNotEmpty ? event.docs.first.data()["message"] : ""
            ..timeLastMessage = event.docs.isNotEmpty
                ? event.docs.first.data()["dateTime"]
                : null;
          listOfGroups.add(groupModel);
          emit(GetGroupsSuccessState());
        });
      }
    }).onError((handleError) {
      emit(GetGroupsErrorState(handleError));
    });
  }

  UserModel? usersInGroupModel;
  List<UserModel> listOfUsersInGroups = [];

  void getUsersInGroups({required String groupId}) async {
    store
        .collection('groups')
        .doc(groupId)
        .collection("users")
        .snapshots()
        .listen((value) {
      listOfUsersInGroups = [];
      for (var element in value.docs) {
        usersInGroupModel = UserModel.fromJson(element.data());
        listOfUsersInGroups.add(usersInGroupModel!);
      }
    });
  }

  List<String> userInGroup = [];

  void setStatusUser({required bool userActive}) {
    store
        .collection("users")
        .doc(currentUserId)
        .update({"userActive": userActive}).then((value) {});
  }

// list to add user active
  List<String> listUserActive = [];
  List<UserModel> usersActiveModel = [];

  void getActiveUsers() {
    emit(GetOnlineUsersLoading());
    for (var phone in phones) {
      String ph = phone.value!.replaceAll(" ", "").replaceAll("-", "");
      store
          .collection("users")
          //  .where("phone", isEqualTo: ph)
          .where("userActive", isEqualTo: true)
          .snapshots()
          .listen((event) {
        usersActiveModel = [];
        listUserActive = [];
        for (var element in event.docs) {
          usersActiveModel.add(UserModel.fromJson(element.data()));
          listUserActive.add(element.id);
        }
        emit(GetActiveUsersSuccess());
      }).onError((handleError) {
        if (kDebugMode) {
          print("$handleError");
        }
      });
    }
  }

  List<String> ids = [];

  void getUsers() {
    emit(GetUsersLoading());
    for (var phone in phones) {
      String ph = phone.value!.replaceAll(" ", "").replaceAll("-", "");
      store
          .collection('users')
          .where("phone", isEqualTo: ph)
          .snapshots()
          .listen((value) {
        emit(GetLastMessageLoading());
        for (var element in value.docs) {
          store
              .collection('users')
              .doc(currentUserId)
              .collection('chats')
              .doc(element.data()['id'])
              .collection('messages')
              .orderBy('dateTime', descending: true)
              .snapshots()
              .listen((event) {
            UserModel userModel = UserModel.fromJson(element.data())
              ..lastMessage = event.docs.isNotEmpty
                  ? event.docs.first.data()["message"]
                  : ""
              ..timeLastMessage = event.docs.isNotEmpty
                  ? event.docs.first.data()["dateTime"]
                  : null;
            if (ids.contains(element.data()["id"]) == false) {
              ids.add(element.id);
              allUsers.add(userModel);
            }
            if (event.docs.first.data()["message"].isNotEmpty) {
              users.add(userModel);
            }

            emit(GetLastMessageSuccess());
          }).onError((handleError) {
            emit(GetLastMessageError());
          });
        }
        emit(GetUsersSuccess());
      }).onError((handleError) {
        emit(GetUsersError(handleError));
      });
    }
  }

  void updateImage({required String groupId}) {
    storage
        .ref()
        .child('groups/${Uri.file(fileImage!.path).pathSegments.last}')
        .putFile(fileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        store.collection('groups').doc(groupId).set({"groupImage": value});
      });
    });
  }

  bool isChecked = false;

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
}
