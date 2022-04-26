import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/views/user/createAccount/enter_user_data_screen.dart';
import 'package:flutter/material.dart';
import '../../shared/Network/local/cache_helper.dart';
import '../../shared/components/user_components.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(),
      body: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            const Spacer(flex: 3),
            Text(
              "Welcome to our freedom \nmessaging app",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  primaryButton(function: () {
                    CacheHelper.saveData(key: 'welcome', value: true);
                    navigatorTo(context: context, page: const EnterUserDataScreen());
                  }, text: "NEXT"),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
