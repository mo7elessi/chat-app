import 'package:chat_app/shared/components/main_components.dart';
import 'package:chat_app/shared/components/profile_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usernameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();
    ChatCubit cubit = ChatCubit.get(context);

    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                children: const [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user_2.png"),
                    maxRadius: 80,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      maxRadius: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              userData(
                text: 'Name',
                data: cubit.user?.username ?? "No Name",
                textButton: "Edit",
                icon: Icons.person,
              ),
              const SizedBox(
                height: 30,
              ),
              userData(
                text: 'Phone',
                data: cubit.user?.phone ?? "No Phone",
                textButton: "Edit",
                icon: Icons.phone,
              ),
              const SizedBox(
                height: 30,
              ),
              userData(
                text: 'Bio',
                data: cubit.user?.bio ?? "No bio",
                textButton: cubit.user?.bio == '' ? "Edit" : "Add",
                icon: Icons.system_update_alt_sharp,
              ),
            ],
          ),
        );
      },
    );
  }
}

