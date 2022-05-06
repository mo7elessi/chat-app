import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../shared/components/chat_components.dart';

// ignore: must_be_immutable
class GroupChatDetailsPage extends StatelessWidget {
  GroupModel groupModel;

  GroupChatDetailsPage({Key? key, required this.groupModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    ChatCubit cubit = ChatCubit.get(context);
    return Builder(
      builder: (context) {
        cubit.getMessagesFromGroup(groupId: groupModel.groupId.toString());
        return BlocConsumer<ChatCubit, ChatStates>(
          listener: (BuildContext context, ChatStates state) {},
          builder: (BuildContext context, ChatStates state) {
            var messageController = TextEditingController();
            return Scaffold(
              key: scaffoldKey,
              appBar: chatDetailsAppBar(
                context: context,
                cubit: cubit,
                username: groupModel.groupName.toString(),
                receiverId: groupModel.groupId.toString(),
                userImage: groupModel.groupImage.toString(),
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 100,
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: cubit.groupMessages.length,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      itemBuilder: (context, index) {
                        if (cubit.groupMessages[index].senderId ==
                            groupModel.adminId.toString()) {
                          return buildReceiverMessage(
                            cubit: cubit,
                            context: context,
                            index: index,
                            message:
                                cubit.groupMessages[index].message.toString(),
                            dateTime:
                                cubit.groupMessages[index].dateTime!.seconds,
                            images: cubit.messages[index].images ?? [],
                          );
                        }
                        return buildSenderMessage(
                          scaffoldKey: scaffoldKey,
                          cubit: cubit,
                          context: context,
                          index: index,
                          dateTime:
                              cubit.groupMessages[index].dateTime!.seconds,
                          message: '',
                          cancelSending: () {
                            cubit.deleteMessage(
                              status: "deleteForAll",
                              receiverId: cubit.groupMessages[index].receiverId
                                  .toString(),
                              messageId: cubit.groupMessages[index].messageId
                                  .toString(),
                            );
                          },
                          deleteMessage: () {
                            cubit.deleteMessage(
                              receiverId: cubit.groupMessages[index].receiverId
                                  .toString(),
                              messageId: cubit.groupMessages[index].messageId
                                  .toString(),
                            );
                          },
                          images: cubit.messages[index].images ?? [],
                        );
                      },
                    ),
                  ),
                  buildInputMessage(
                    context: context,
                    messageController: messageController,
                    function: () {
                      if (messageController.text.isNotEmpty) {
                        cubit.sendMessageToGroup(
                          receiverId: groupModel.groupId.toString(),
                          message: messageController.text,
                          messageId: const Uuid().v4(),
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
