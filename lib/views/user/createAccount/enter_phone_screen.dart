import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/components/user_components.dart';
import 'package:chat_app/views/user/createAccount/verify_phone_screen.dart';
import 'package:chat_app/views/user/cubit/cubit.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EnterPhoneScreen extends StatelessWidget {
  const EnterPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    UserCubit cubit = UserCubit.get(context);

    return BlocConsumer<UserCubit, UserStates>(
      listener: (context,UserStates state) {
      },
      builder: (context,UserStates state) {
        String code = '';
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
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  spaceBetween(),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IntlPhoneField(
                          initialCountryCode: 'IN',
                          controller: phoneController,
                          pickerDialogStyle: PickerDialogStyle(
                            searchFieldInputDecoration: InputDecoration(
                              hintText: 'Search about your country code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: const BorderSide(
                                    width: 0.3, color: Color(0xff979191)),
                              ),
                            ),
                          ),
                          showCountryFlag: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: const BorderSide(
                                  width: 0.3, color: Color(0xff979191)),
                            ),
                          ),
                          onChanged: (phone) {
                            code = phone.countryCode;
                          },
                          //showDropdownIcon: ,
                          onCountryChanged: (country) {},
                        ),
                      ],
                    ),
                  ),
                  if (state is VerificationFailedState)
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  spaceBetween(size: 24),
                  ConditionalBuilder(
                    condition: state is! VerifyPhoneNumberLoadingState,
                    builder: (context) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: secondaryButton(
                              text: "Previous",
                              function: () {
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
                              text: cubit.sent?'Enter Code': 'Send Code',
                              function: () {
                                if(!cubit.sent) {
                                  if (phoneController.text.isNotEmpty) {
                                    cubit.phoneNumber =
                                        "$code ${phoneController.text}";
                                    toastMessage(
                                        message:
                                            "$code ${phoneController.text}");
                                    cubit.loginWithPhone(
                                        phoneNumber:
                                            "$code ${phoneController.text}");
                                  }
                                }else{
                                  cubit.startTimer();
                                  navigatorTo(
                                    context: context,
                                    page: const VerifyPhoneScreen(),
                                  );
                                }
                              },
                            ),
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
        ));
      },
    );
  }
}
