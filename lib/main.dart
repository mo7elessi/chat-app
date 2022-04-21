import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app/layout/main_layout.dart';
import 'package:chat_app/shared/components/main_components.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/cubit/bloc_observe.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/Network/local/cache_helper.dart';
import 'package:chat_app/shared/network/remote/dio_helper.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/shared/style/themes.dart';
import 'package:chat_app/views/user/createAccount/enter_user_data_screen.dart';
import 'package:chat_app/views/user/cubit/cubit.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:chat_app/views/welcome/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  });
  //اذا كان التطبيق مفتوح foreground
  FirebaseMessaging.onMessage.listen((event) {
    toastMessage(message: event.notification!.title.toString());
  });

  //when click on notification
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});

  //background اذا كان التطبيق في الخلفية
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  userId = CacheHelper.getData(key: 'id');
  page = userId != '' ? const HomeLayout() : const EnterUserDataScreen();

  runApp(ChatApp(id: userId, startScreen: page!));
}

class ChatApp extends StatelessWidget {
  final String id;
  final Widget startScreen;

  const ChatApp({Key? key, required this.id, required this.startScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _askPermissions(context: context,routeName: "");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ChatCubit()
              ..getContacts()
              ..getUsers()
              ..getActiveUsers()
              ..getUserData()
              ..getGroups()),
        BlocProvider(create: (context) => UserCubit()),

      ],
      child: BlocConsumer<UserCubit, UserStates>(
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, state) => MaterialApp(
          title: 'Chat App',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home:LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return  AnimatedSplashScreen(
              splash: const SplashPage(),
              backgroundColor: primaryColor,
              nextScreen: const EnterUserDataScreen(),
              splashTransition: SplashTransition.scaleTransition,
              animationDuration: const Duration(milliseconds: 500),
            );
          },),
        ),
      ),
    );
  }
}
