import 'package:chat_app/layout/main_layout.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/main_components.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/user/cubit/cubit.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/shared/components/user_components.dart';

class VerifyPhoneScreen extends StatelessWidget {
  String phoneNumber;
  String username;

  VerifyPhoneScreen({
    Key? key,
    required this.phoneNumber,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var otpController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is VerifyOTPSuccessState) {
          navigatorTo(context: context, page: const HomeLayout());
        }
      },
      builder: (context, state) {
        UserCubit cubit = UserCubit.get(context);

        return Scaffold(
          appBar: userAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text.rich(
                      TextSpan(
                          style: const TextStyle(height: 1.4, fontSize: 14),
                          text:
                              'A 6-digit message has been sent to the number ',
                          children: <InlineSpan>[
                            TextSpan(
                              text: phoneNumber,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                  spaceBetween(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        textInputFieldToOTP(
                            controller: otpController,
                            context: context,
                            onChange: (value) {
                              if (otpController.text.length == 6) {
                                cubit.verifyOTP(
                                    smsCode: otpController.text,
                                    phoneNumber: phoneNumber,
                                    username: username,
                                    context: context);
                              }
                            }),
                        spaceBetween(size: 12),
                        if (state is VerifyOTPErrorState)
                          Text(
                            state.error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  spaceBetween(),
                  ConditionalBuilder(
                    condition: state is! VerifyOTPLoadingState,
                    builder: (context) {
                      return Column(
                        children: [
                          spaceBetween(size: 12),
                          const Text(
                              'I haven\'t received a resend message yet '),
                          TextButton(
                            onPressed: () {
                              cubit.loginWithPhone(phoneNumber: cubit.phoneNumber);
                              cubit.startTimer();
                            },
                            child: Text(
                              cubit.start > 0
                                  ? "${cubit.start}"
                                  : "Resend code",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ),
                          spaceBetween(size: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Change Phone Number"),
                          ),
                        ],
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
        );
      },
    );
  }
}
