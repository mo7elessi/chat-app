import 'dart:io';
import 'dart:ui';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/chat/chat_details_screen.dart';
import 'package:chat_app/views/group/group_details_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../views/chat/video_audio_call.dart';
import '../services/fcm_notifications_servicess.dart';

Widget buildChatItem({
  required BuildContext context,
  required UserModel userModel,
  required int index,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  ChatCubit cubit = ChatCubit.get(context);
  return InkWell(
    focusColor: Colors.grey,
    onTap: () {
      navigatorTo(
        context: context,
        page: ChatDetailsPage(userModel: userModel),
      );
    },
    onLongPress: () {
      showBottomSheet(
        context: context,
        scaffoldKey: scaffoldKey,
        column: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bottomSheetAction(
              icon: Icons.delete,
              color: Colors.red,
              context: context,
              text: "Delete chat".toUpperCase(),
              function: () {
                ChatCubit.get(context).deleteChat(
                  receiverId: userModel.id.toString(),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userModel.image.toString()),
                      maxRadius: 25,
                    ),
                    if (cubit.listUserActive.contains(userModel.id.toString()))
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              userModel.username.toString(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff383838),
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if (userModel.lastMessage != null)
                              Text(
                                cubit.readTimestamp(
                                    userModel.timeLastMessage?.seconds),
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                          ],
                        ),
                        if (userModel.lastMessage != null)
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                userModel.lastMessage.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildGroupChatItem({
  required BuildContext context,
  required GroupModel groupModel,
  required int index,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  ChatCubit cubit = ChatCubit.get(context);
  return InkWell(
    focusColor: Colors.grey,
    onTap: () {
      navigatorTo(
        context: context,
        page: GroupChatDetailsPage(groupModel: groupModel),
      );
    },
    onLongPress: () {
      showBottomSheet(
        scaffoldKey: scaffoldKey,
        column: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bottomSheetAction(
              icon: Icons.delete,
              color: Colors.red,
              context: context,
              text: "Delete chat".toUpperCase(),
              function: () {
                ChatCubit.get(context).deleteChat(
                  receiverId: groupModel.groupId.toString(),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
        context: context,
      );
    },
    child: Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(groupModel.groupImage.toString()),
                      maxRadius: 25,
                    ),
                    //  if (cubit.listUserActive.contains(userModel.id.toString()))
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              groupModel.groupName.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff383838),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (groupModel.lastMessage != "")
                              Text(
                                cubit.readTimestamp(
                                    groupModel.timeLastMessage?.seconds),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        if (groupModel.lastMessage != "")
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                groupModel.lastMessage.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget bottomSheetAction({
  required String text,
  required BuildContext context,
  required Function function,
  required IconData icon,
  required Color color,
}) {
  return InkWell(
    onTap: () => function(),
    focusColor: Colors.green,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(
              width: 5,
            ),
            Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color, fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

Future<void> showBottomSheet({
  required GlobalKey<ScaffoldState> scaffoldKey,
  required Column column,
  required BuildContext context,
}) {
  return scaffoldKey.currentState!
      .showBottomSheet(
        (context) => Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: column,
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 4.0,
      )
      .closed
      .then((value) {
    ChatCubit.get(context).changeBottomSheetState(
        isShow: ChatCubit.get(context).isBottomSheetShown);
  });
}

AppBar chatDetailsAppBar({
  required ChatCubit cubit,
  required BuildContext context,
  required String userImage,
  required String username,
  required String receiverId,
}) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: primaryColor,
    flexibleSpace: SafeArea(
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(userImage),
              maxRadius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    username,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    cubit.listUserActive.contains(receiverId)
                        ? "Online"
                        : "Offline",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.phone),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                navigatorTo(
                    context: context, page: const VideoAudioCallScreen());
              },
              icon: const Icon(Icons.video_call),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info),
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildReceiverMessage({
  required ChatCubit cubit,
  required BuildContext context,
  required int index,
  required int dateTime,
  required String message,
  required List<String> images,
}) {
  int count;
  if (images.length == 1) {
    count = 1;
  } else if (images.length == 2) {
    count = 2;
  } else if (images.length == 3) {
    count = 3;
  } else {
    count = 4;
  }
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(left: 50, top: 10, right: 10),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: count,
              children: List.generate(images.length, (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            ),
          ),
        if (message.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(left: 10, top: 10, right: 50),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(message, style: const TextStyle(fontSize: 12)),
          ),
        Container(
          margin: const EdgeInsets.only(top: 5, left: 10),
          child: Text(
            cubit.readTimestamp(dateTime),
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}

Widget buildSenderMessage({
  required ChatCubit cubit,
  required BuildContext context,
  required int index,
  required GlobalKey<ScaffoldState> scaffoldKey,
  required Function deleteMessage,
  required Function cancelSending,
  required String message,
  required int dateTime,
  required List<String> images,
}) {
  int count;
  if (images.length == 1) {
    count = 1;
  } else if (images.length == 2) {
    count = 2;
  } else if (images.length == 3) {
    count = 3;
  } else {
    count = 4;
  }
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onLongPress: () {
            showBottomSheet(
              context: context,
              scaffoldKey: scaffoldKey,
              column: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bottomSheetAction(
                    icon: Icons.delete,
                    color: Colors.red,
                    context: context,
                    text: "Delete message".toUpperCase(),
                    function: () => deleteMessage(),
                  ),
                  bottomSheetAction(
                    icon: Icons.cancel_schedule_send,
                    color: Colors.blue,
                    context: context,
                    text: "Cancel sending".toUpperCase(),
                    function: () => cancelSending(),
                  ),
                ],
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (images.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 50, top: 10, right: 10),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: count,
                    children: List.generate(images.length, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: NetworkImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              if (message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(left: 50, top: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5, right: 10),
          child: Text(
            cubit.readTimestamp(dateTime),
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}

FCMNotificationServices fcm = FCMNotificationServices();

Widget buildInputMessage({
  required BuildContext context,
  required TextEditingController messageController,
  required Function function,
}) {
  ChatCubit cubit = ChatCubit.get(context);

  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      height: cubit.imageFileList.isNotEmpty ? 200 : 70,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: cubit.imageFileList.isNotEmpty ? true : false,
            child: Expanded(
              flex: 2,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                dragStartBehavior: DragStartBehavior.start,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: FileImage(
                                File(cubit.imageFileList[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () {
                          cubit.clearImageByIndex(
                              file: cubit.imageFileList[index]);
                        },
                      ),
                    ],
                  );
                },
                itemCount: cubit.imageFileList.length,
                separatorBuilder: (context, index) {
                  return spaceBetween(vertical: false, size: 5);
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cubit.pickMultiImageFromGallery();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
                spaceBetween(vertical: false, size: 5),
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      isDense: true,
                      focusedBorder: InputBorder.none,
                      hintText: "Type message here...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                  ),
                ),
                spaceBetween(),
                GestureDetector(
                  onTap: () => function(),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child:
                        const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

List<String> usersId = [];

Widget buildSelectItemToAddToYourGroup(
    {required UserModel userModel,
    required BuildContext context,
    required int index}) {
  ChatCubit cubit = ChatCubit.get(context);
  return CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    activeColor: primaryColor,
    title: Text(
      userModel.username.toString(),
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    ),
    value: cubit.allUsers[index].isChecked,
    secondary: CircleAvatar(
      backgroundImage: NetworkImage(userModel.image.toString()),
      maxRadius: 20,
    ),
    onChanged: (value) {
      if (value!) {
        cubit.count++;
      } else {
        cubit.count--;
      }
      cubit.changeState(index, value);
      if (cubit.allUsers[index].isChecked!) {
        usersId.add(cubit.allUsers[index].id!);
      }
    },
  );
}
