// ignore_for_file: must_be_immutable

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../shared/components/chat_components.dart';

class ChatDetailsPage extends StatelessWidget {
  UserModel userModel;

  ChatDetailsPage({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    ChatCubit cubit = ChatCubit.get(context);
    return Builder(
      builder: (context) {
        cubit.getMessages(receiverId: userModel.id.toString());
        return BlocConsumer<ChatCubit, ChatStates>(
          listener: (BuildContext context, ChatStates state) {},
          builder: (BuildContext context, ChatStates chatState) {
            var messageController = TextEditingController();
            return Scaffold(
              key: scaffoldKey,
              appBar: chatDetailsAppBar(
                context: context,
                cubit: cubit,
                username: userModel.username.toString(),
                receiverId: userModel.id.toString(),
                userImage: userModel.image.toString(),
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 100,
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: cubit.messages.length,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      itemBuilder: (context, index) {
                        if (cubit.messages[index].senderId ==
                            userModel.id.toString()) {
                          return buildReceiverMessage(
                            cubit: cubit,
                            context: context,
                            index: index,
                            message: cubit.messages[index].message.toString(),
                            dateTime: cubit.messages[index].dateTime!.seconds,
                            images: cubit.messages[index].images ?? [],
                          );
                        }
                        return buildSenderMessage(
                            scaffoldKey: scaffoldKey,
                            dateTime: cubit.messages[index].dateTime!.seconds,
                            cancelSending: () {
                              cubit.deleteMessage(
                                status: "deleteForAll",
                                receiverId:
                                    cubit.messages[index].receiverId.toString(),
                                messageId:
                                    cubit.messages[index].messageId.toString(),
                              );
                            },
                            deleteMessage: () {
                              cubit.deleteMessage(
                                receiverId:
                                    cubit.messages[index].receiverId.toString(),
                                messageId:
                                    cubit.messages[index].messageId.toString(),
                              );
                            },
                            message: cubit.messages[index].message.toString(),
                            cubit: cubit,
                            context: context,
                            index: index,
                            images: cubit.messages[index].images ?? []);
                      },
                    ),
                  ),
                  buildInputMessage(
                    context: context,
                    messageController: messageController,
                    function: () {
                      String messageId = const Uuid().v4();
                      if (messageController.text.isNotEmpty
                          || cubit.imageFileList.isNotEmpty) {
                        if (cubit.imageFileList.isEmpty) {
                          cubit.sendMessage(
                            receiverId: userModel.id.toString(),
                            message: messageController.text ,
                            messageId: messageId,
                          );
                        }else {
                          cubit.uploadMultiImage(
                            receiverId: userModel.id.toString(),
                            messageId: messageId,
                            message: messageController.text,
                          );
                        }
                        fcm.sendNotificationToUser(
                          token: userModel.token.toString(),
                          title: userModel.username.toString(),
                          body: messageController.text,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
