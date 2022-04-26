import 'package:chat_app/layout/main_layout.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/style/colors.dart';
import 'package:chat_app/views/user/cubit/cubit.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/shared/components/user_components.dart';

import '../../../shared/Network/local/cache_helper.dart';

class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var otpController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    UserCubit cubit = UserCubit.get(context);

    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is VerifyOTPSuccessState) {
          CacheHelper.saveData(key: 'id', value: cubit.userId);
          navigatorTo(context: context, page: const HomeLayout());
        }
        if (cubit.sent == true||state is CodeSentState) {
          cubit.startTimer();
        }
      },
      builder: (context, state) {
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
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                          text:
                              'A 6-digit message has been sent to the number ',
                          children: <InlineSpan>[
                            TextSpan(
                              text: cubit.phoneNumber,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
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
                                    phoneNumber: cubit.phoneNumber,
                                    username:
                                        cubit.username ?? cubit.phoneNumber,
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
                          spaceBetween(size: 10),
                          ConditionalBuilder(
                            condition: state is! VerifyPhoneNumberLoadingState,
                            builder: (context) {
                              return TextButton(
                                onPressed: () {
                                  cubit.loginWithPhone(
                                      phoneNumber: cubit.phoneNumber);
                                },
                                child: Text(
                                  cubit.start > 0
                                      ? "${cubit.start}"
                                      : "Re-send code",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              );
                            },
                            fallback: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          spaceBetween(size: 24),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: secondaryButton(
                                  text: "Previous",
                                  function: () {
                                    cubit.sent = false;
                                    cubit.start = 0;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: primaryButton(
                                  text: 'Change phone',
                                  function: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
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
