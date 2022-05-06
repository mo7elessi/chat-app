import 'package:chat_app/layout/main_layout.dart';
import 'package:chat_app/shared/components/chat_components.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineUsersPage extends StatelessWidget {
  const OnlineUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
        condition:ChatCubit.get(context).usersActiveModel.isNotEmpty,
        fallback: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        builder: (context) {
          return  ListView.builder(
              itemCount: ChatCubit.get(context).usersActiveModel.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildChatItem(
                    userModel: ChatCubit.get(context).usersActiveModel[index],
                    scaffoldKey: HomeLayout.scaffoldKey,
                    context: context,
                    index: index);
              },
          );
        },
      ),
    );
  }
}
