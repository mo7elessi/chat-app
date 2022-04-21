import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/main_components.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    navigatorTo(context: context, page: HomePage());
                  }, text: "NEXT"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
