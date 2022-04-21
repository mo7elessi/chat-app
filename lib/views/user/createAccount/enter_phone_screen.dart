import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/main_components.dart';
import 'package:chat_app/shared/components/user_components.dart';
import 'package:chat_app/shared/validation/text_feild_validation.dart';
import 'package:chat_app/views/user/createAccount/verify_phone_screen.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

class EnterPhoneScreen extends StatelessWidget {
  String username;

  EnterPhoneScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    UserCubit cubit = UserCubit.get(context);

    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (cubit.otpVisibility == false) {
          navigatorTo(
            context: context,
            page: VerifyPhoneScreen(
              phoneNumber: "${cubit.selectedItem}${phoneController.text}",
              username: username,
            ),
          );
          cubit.phoneNumber = "${cubit.selectedItem}${phoneController.text}";
          cubit.startTimer();
        }
        switch(state){

        }
      },
      builder: (context, state) {
        return SafeArea(
            child: Scaffold(
          appBar: userAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "We'll need to verify your phone number",
                    style: TextStyle(fontSize: 14),
                  ),
                  spaceBetween(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              textInputField(
                                context: context,
                                controller: phoneController,
                                keyboard: TextInputType.text,
                                hintText: 'Enter Phone here',
                                prefixIcon: Icons.phone,
                                validator: none,
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: DropdownButton(
                                   enableFeedback: true,
                                    menuMaxHeight: 200,
                                    hint: const Text("Click here"),
                                    value: cubit.selectedItem,
                                    alignment: AlignmentDirectional.centerStart,
                                    dropdownColor: Colors.white,
                                    isDense: false,
                                    underline: const SizedBox(),
                                    elevation: 0,
                                    items: List.generate(countryCode.length,
                                        (int index) {
                                      return DropdownMenuItem(
                                        onTap: () {},
                                        value: countryCode[index][0],
                                        alignment: AlignmentDirectional.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  countryCode[index][1]),
                                              width: 30,
                                              height: 20,
                                              fit: BoxFit.fill,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              countryCode[index][0],
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    onChanged: (value) {
                                      cubit.selected(value.toString());
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (state is VerificationFailedState)
                          Text(
                            state.error,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  spaceBetween(size: 24),
                  ConditionalBuilder(
                    condition: state is! VerifyPhoneNumberLoadingState,
                    builder: (context) {
                      return primaryButton(
                        text: 'Next',
                        function: () {
                          cubit.loginWithPhone(
                              phoneNumber:
                                  "${cubit.selectedItem} ${phoneController.text}");
                        },
                      );
                    },
                    fallback: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}

String path = "assets/images/flags";
List<List<String>> countryCode = [
  ["+972", "$path/ps.png"],
  ["+970", "$path/ps.png"],
  ["+971", "$path/ps.png"],
  ["+978", "$path/ps.png"],
];
