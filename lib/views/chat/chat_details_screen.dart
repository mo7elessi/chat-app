import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/chat_components.dart';

class ChatDetailsPage extends StatelessWidget {
  String receiverId;
  String username;
  String token;
  String userImage;
  String? bio;

  ChatDetailsPage({
    Key? key,
    required this.receiverId,
    required this.username,
    required this.token,
    required this.bio,
    required this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    ChatCubit cubit = ChatCubit.get(context);
    return Builder(
      builder: (context) {
        ChatCubit.get(context).getMessages(receiverId: receiverId);
        return BlocConsumer<ChatCubit, ChatStates>(
          listener: (BuildContext context, ChatStates state) {},
          builder: (BuildContext context, ChatStates state) {
            var messageController = TextEditingController();
            return Scaffold(
              key: scaffoldKey,
              appBar: chatDetailsAppBar(
                context: context,
                cubit: cubit,
                username: username,
                receiverId: receiverId,
                userImage: userImage,
              ),
              body: Column(
                children: <Widget>[
                 // // if (cubit.messages.isEmpty)
                 //  Column(
                 //      children: [
                 //        CircleAvatar(
                 //          backgroundImage: NetworkImage(userImage),
                 //          maxRadius: 50,
                 //        ),
                 //        spaceBetween(),
                 //
                 //        spaceBetween(),
                 //        Text(
                 //          bio ?? "",
                 //          style: const TextStyle(
                 //              color: Colors.black87, fontSize: 12),
                 //        ),
                 //      ],
                 //    ),
                  Expanded(
                    flex: 100,
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: cubit.messages.length,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      // physics: const (),
                      itemBuilder: (context, index) {
                        if (cubit.messages[index].senderId == receiverId) {
                          return buildSenderMessage(
                              cubit: cubit,
                              context: context,
                              index: index,
                             );
                        }
                        return buildReceiverMessage(
                            scaffoldKey: scaffoldKey, receiverId: receiverId,
                            messageId: cubit.messages[index].messageId.toString(),
                            cubit: cubit, context: context, index: index);
                      },
                    ),
                  ),
                  buildInputMessage(
                    cubit: cubit,
                    context: context,
                    messageController: messageController,
                    receiverId: receiverId,
                    username: username,
                    token: token,
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
