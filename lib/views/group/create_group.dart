import 'package:chat_app/shared/components/chat_components.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/shared/validation/text_feild_validation.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../shared/cubit/cubit.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupName = TextEditingController();
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (BuildContext context, ChatStates state) {
        if (state is GetGroupsSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, ChatStates state) {
        ChatCubit cubit = ChatCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "CREATE NEW GROUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  String groupId = const Uuid().v4();
                  cubit.createGroup(
                    groupName: groupName.text,
                    groupId: groupId,
                  );
                  for (var element in usersId) {
                    //check here ...
                    cubit.setNewUserInGroup(
                      userId: element,
                      groupId: groupId,
                    );
                  }
                },
              )
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! CreateGroupLoading,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Stack(
                      //   alignment: Alignment.bottomLeft,
                      //   children: [
                      //     Container(
                      //       height: 100,
                      //       width: 100,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100.0),
                      //         image: cubit.fileImage == null
                      //             ? const DecorationImage(
                      //                 image: AssetImage(
                      //                     "assets/images/defaultImage.jpg"),
                      //                 fit: BoxFit.cover,
                      //               )
                      //             : DecorationImage(
                      //                 image: FileImage(cubit.fileImage!),
                      //                 fit: BoxFit.cover,
                      //               ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       right: 0,
                      //       bottom: 0,
                      //       child: InkWell(
                      //         child: const CircleAvatar(
                      //           backgroundColor: primaryColor,
                      //           child: Icon(
                      //             Icons.camera_alt,
                      //             color: Colors.white,
                      //             size: 20,
                      //           ),
                      //           maxRadius: 20,
                      //         ),
                      //         onTap: () {
                      //           cubit.pickImageFromGallery();
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: const [
                            Text(
                              "ENTER GROUP NAME",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff383838),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "OPTIONAl",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      textInputField(
                          controller: groupName,
                          keyboard: TextInputType.name,
                          validator: nameValidator,
                          hintText: '',
                          context: context,
                          icon: false,
                          prefixIcon: Icons.groups),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Text(
                              "SELECT USERS",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff383838),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              cubit.count > 0
                                  ? "${cubit.count} USER"
                                  : "NOT SELECTED USER",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemCount: cubit.allUsers.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildSelectItemToAddToYourGroup(
                            userModel: cubit.allUsers[index],
                            context: context,
                            index: index,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            fallback: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
