import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/components/profile_components.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/group/create_group.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user/cubit/cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCubit cubit = UserCubit.get(context);
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      image: cubit.user?.image != null
                          ? DecorationImage(
                              image: NetworkImage(cubit.user!.image.toString()),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: FileImage(cubit.userImage!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      child: const CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                        maxRadius: 25,
                      ),
                      onTap: () {
                        cubit.pickProfileImage();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: primaryButton(function: () {
                      navigatorTo(context: context, page: const CreateGroupScreen());
                    }, text: "New Group"),
                  ),
                  const SizedBox(width: 10.0),

                  Expanded(
                    flex: 1,
                    child:
                        secondaryButton(function: () {}, text: "New Contact"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              userData(
                text: 'Name',
                data: cubit.user?.username ?? "No Name",
                textButton: "Edit",
                icon: Icons.person,
              ),
              const SizedBox(height: 30),
              userData(
                text: 'Phone',
                data: cubit.user?.phone ?? "No Phone",
                textButton: "Edit",
                icon: Icons.phone,
              ),
              const SizedBox(height: 30),
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
