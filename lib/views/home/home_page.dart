import 'package:chat_app/layout/main_layout.dart';
import 'package:chat_app/shared/components/chat_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit.get(context);

    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (BuildContext context, ChatStates state) {},
      builder: (BuildContext context, state) {
        return ConditionalBuilder(
          condition: state is! GetUsersLoading,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) {
            return ListView.builder(
              itemCount: cubit.users.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildChatItem(
                  model: cubit.users[index],
                  scaffoldKey: HomeLayout.scaffoldKey,
                  context: context,
                  index: index,
                );
              },
            );
          },
        );
      },
    );
  }
}
