import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app/layout/main_layout.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/cubit/bloc_observe.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/Network/local/cache_helper.dart';
import 'package:chat_app/shared/network/remote/dio_helper.dart';
import 'package:chat_app/shared/style/themes.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:chat_app/views/profile/profile_page.dart';
import 'package:chat_app/views/user/createAccount/enter_phone_screen.dart';
import 'package:chat_app/views/user/createAccount/enter_user_data_screen.dart';
import 'package:chat_app/views/user/cubit/cubit.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:chat_app/views/welcome/splash_page.dart';
import 'package:chat_app/views/welcome/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'shared/services/permissions.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  switch (message) {
  }
}

Widget? page;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();

  //firebase messaging
  FirebaseMessaging.instance.getToken().then((value) {
    token = value!;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"token": value});
  });
  //اذا كان التطبيق مفتوح foreground
  FirebaseMessaging.onMessage.listen((event) {
    toastMessage(message: event.notification!.title.toString());
  });

  //when click on notification
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    toastMessage(message: event.notification!.title.toString());
  });

  //background اذا كان التطبيق في الخلفية
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  userId = CacheHelper.getData(key: 'id');
  bool welcomeIsTrue = CacheHelper.getData(key: 'welcome');
  if (welcomeIsTrue == false || welcomeIsTrue == null) {
    page = const WelcomePage();
  } else if (userId == null) {
    page = const EnterPhoneScreen();
  } else {
    page = const HomeLayout();
  }

  runApp(ChatApp(id: userId, startScreen: page!));
}

class ChatApp extends StatefulWidget with WidgetsBindingObserver {
  final String id;
  final Widget startScreen;

  const ChatApp({Key? key, required this.id, required this.startScreen})
      : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  void initState() {
    if (kDebugMode) {
      print("app lifecycle: initState");
    }
    super.initState();
  }

  @override
  void activate() {
    if (kDebugMode) {
      print("app lifecycle: activate");
    }
    super.activate();
  }

  @override
  void deactivate() {
    if (kDebugMode) {
      print("app lifecycle: deactivate");
    }
    super.deactivate();
  }

  @override
  void reassemble() {
    if (kDebugMode) {
      print("app lifecycle: reassemble");
    }
    super.reassemble();
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("app lifecycle: dispose");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getContacts();
    Permissions().askPermissions("", context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ChatCubit()
              ..getUsers()
              ..getActiveUsers()
              ..getGroups()),
        BlocProvider(create: (context) => UserCubit()..getUserData()),
      ],
      child: BlocConsumer<UserCubit, UserStates>(
          listener: (BuildContext context, UserStates state) {},
          builder: (BuildContext context, UserStates state) {
            return MaterialApp(
              title: 'Chat App',
              theme: theme,
              debugShowCheckedModeBanner: false,
              home: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AnimatedSplashScreen(
                    splash: const SplashPage(),
                    backgroundColor: Colors.white,
                    nextScreen: widget.startScreen,
                    splashTransition: SplashTransition.scaleTransition,
                    animationDuration: const Duration(milliseconds: 500),
                  );
                },
              ),
              routes: {
                "homePage": (_) => const HomePage(),
                "profilePage": (_) => const ProfilePage(),
              },
            );
          }),
    );
  }
}
