import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/chat/chat_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../views/chat/video_audio_call.dart';
import '../services/fcm_notifications_servicess.dart';

Widget buildChatItem({
  required BuildContext context,
  required UserModel model,
  required int index,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  return InkWell(
    focusColor: Colors.grey,
    onTap: () {
      navigatorTo(
          context: context,
          page: ChatDetailsPage(
            token: model.token ?? "",
            receiverId: model.id!,
            username: model.username!,
            bio: model.bio,
            userImage: model.image!,
          ));
    },
    onLongPress: () {
      scaffoldKey.currentState!.showBottomSheet(
            (context) =>
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: const ButtonStyle(
                          alignment: AlignmentDirectional.bottomStart),
                      child: const Text(
                        'Delete Chat',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      onPressed: () {
                        ChatCubit.get(context).deleteChat(
                          receiverId: model.id.toString(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: const ButtonStyle(
                          alignment: AlignmentDirectional.bottomStart),
                      child: const Text(
                        'Block User',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: const ButtonStyle(
                          alignment: AlignmentDirectional.bottomStart),
                      child: Text(
                        'Create Group with ${model.username}',
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
        clipBehavior: Clip.hardEdge,
        elevation: 4.0,
      );
    },
    child: Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          model.image ?? "assets/images/logoChat.png"),
                      maxRadius: 30,
                    ),
                    if (ChatCubit
                        .get(context)
                        .listUserActive
                        .contains(model.id))
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                                width: 3),
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
                              model.username.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff383838),
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if(model.lastMessage != null)
                              Text(
                                ChatCubit.get(context).readTimestamp(
                                    model.timeLastMessage!.seconds),
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                          ],
                        ),
                       if (model.lastMessage != null)
                          Column(children: [
                            const SizedBox(height: 10),
                            Text(
                              "${model.lastMessage}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],),

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
                        fontSize: 16,
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
                navigatorTo(context: context, page: const VideoAudioCallScreen());
              },
              icon: const Icon(Icons.video_call),
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildSenderMessage({
  required ChatCubit cubit,
  required BuildContext context,
  required int index,
}) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(left: 10, top: 5, right: 50),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text("${cubit.messages[index].message}"),
        ),

        Container(
          margin: const EdgeInsets.only(top: 5, left: 10),
          child: Text(
            cubit.readTimestamp(cubit.messages[index].dateTime!.seconds),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}

Widget buildReceiverMessage({
  required ChatCubit cubit,
  required BuildContext context,
  required int index,
  required String receiverId,
  required String messageId,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onLongPress: () {
            scaffoldKey.currentState!.showBottomSheet(
                  (context) =>
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: const ButtonStyle(
                                alignment: AlignmentDirectional.bottomStart),
                            child: const Text(
                              'Delete Message',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 16),
                            ),
                            onPressed: () {
                              ChatCubit.get(context).deleteMessage(
                                receiverId: receiverId,
                                messageId: messageId,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: const ButtonStyle(
                                alignment: AlignmentDirectional.bottomStart),
                            child: const Text(
                              'Cancel Sending',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 16),
                            ),
                            onPressed: () {
                              ChatCubit.get(context).deleteMessage(
                                  receiverId: receiverId,
                                  messageId: messageId,
                                  status: "deleteForAll");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              clipBehavior: Clip.hardEdge,
              elevation: 4.0,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(left: 50, top: 5, right: 10),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              "${cubit.messages[index].message}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 5, right: 10),
          child: Text(
            cubit.readTimestamp(cubit.messages[index].dateTime!.seconds),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}

Widget buildInputMessage({
  required ChatCubit cubit,
  required BuildContext context,
  required TextEditingController messageController,
  required String receiverId,
  required String username,
  required String token,
}) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
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
            onTap: () {
              if (messageController.text == '') {} else {
                cubit.sendMessage(
                    receiverId: receiverId,
                    messageId: const Uuid().v4(),
                    message: messageController.text);

                // cubit.sendNotification(
                //     token: token,
                //     title: username,
                //     body: messageController.text);
                FCMNotificationServices().sendNotificationToUser(
                    token: token,
                    title: username,
                    body: messageController.text);
              }
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
