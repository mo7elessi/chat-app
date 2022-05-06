
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/state.dart';
import 'package:chat_app/shared/Network/local/cache_helper.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/user/createAccount/enter_phone_screen.dart';
import 'package:chat_app/views/user/createAccount/enter_user_data_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/group/create_group.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);
  static var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit.get(context);
    return BlocConsumer<ChatCubit, ChatStates>(
        listener: (BuildContext context, ChatStates state) {},
        builder: (BuildContext context, ChatStates state) {
          int homeIndex = 0;
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              title: Text(cubit.appBarTitle[cubit.currentIndex].toUpperCase()),
              actions: [
                if (cubit.currentIndex == 1)
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        navigatorTo(
                            context: context, page: const CreateGroupScreen());
                      }),
                if (cubit.currentIndex == 3)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      CacheHelper.clearData(key: 'id').then(
                        (value) {
                          navigatorTo(
                              context: context,
                              page: const EnterPhoneScreen());
                        },
                      );
                    },
                  ),
              ],
            ),
            body: cubit.buildPages[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              items: cubit.navBarsItems,
              onTap: (index) {
                cubit.onClickItemNavigation(index);
              },
            ),
          );
        });
  }
}
