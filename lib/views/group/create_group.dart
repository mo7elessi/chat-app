import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:chat_app/shared/validation/text_feild_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/cubit.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupName = TextEditingController();
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (BuildContext context, ChatStates state) {},
      builder: (BuildContext context, ChatStates state) {
        ChatCubit cubit = ChatCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("CREATE NEW GROUP"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                textInputField(
                    controller: groupName,
                    keyboard: TextInputType.name,
                    validator: nameValidator,
                    hintText: 'Enter Group name',
                    context: context,
                    icon: false),
                const Spacer(),
                primaryButton(
                    function: () {
                      cubit.createGroup(groupName: groupName.text);
                    },
                    text: "Create group"),
                const SizedBox(height: 5),
                primaryButton(
                    function: () {
                      cubit.getUsersInGroup(
                          groupId: "a7a2f6f1-fd60-426c-9fdd-023db585d0f7");
                    },
                    text: "Get user from group"),
                const SizedBox(height: 5),
                primaryButton(
                    function: () {
                      cubit.deleteUserFromGroup(
                          groupId: "a7a2f6f1-fd60-426c-9fdd-023db585d0f7",
                          userId: 'M4TinWrAA9gpnotpXWl6NFxYeNp1');
                    },
                    text: "Delete user from group"),
                const SizedBox(height: 5),
                primaryButton(
                    function: () {
                      cubit.setNewUserInGroup(
                          groupId: "a7a2f6f1-fd60-426c-9fdd-023db585d0f7",
                          userId: "M4TinWrAA9gpnotpXWl6NFxYeNp1");
                    },
                    text: "Set new user in group"),
                const SizedBox(height: 5),
                primaryButton(
                    function: () {
                      cubit.sendMessageToGroup(
                          messageId: '111111',
                          receiverId: 'a7a2f6f1-fd60-426c-9fdd-023db585d0f7',
                          message: 'Hello');
                    },
                    text: "Send message"),
              ],
            ),
          ),
        );
      },
    );
  }
}
