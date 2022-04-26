import 'dart:async';
import 'dart:io';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/Network/local/cache_helper.dart';
import 'package:chat_app/shared/components/shared_components.dart';
import 'package:chat_app/shared/components/constance.dart';
import 'package:chat_app/views/user/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);

  //firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
 final FirebaseFirestore store = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String? username;
  File? userImage;

  void createUser({
    required String id,
    required String username,
    required String email,
    required bool isEmailVerified,
  }) {
    UserModel user = UserModel(
      token: token,
      id: id,
      username: username,
      email: email,
      isEmailVerified: isEmailVerified,
    );
    store.collection('users').doc(id).set(user.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((onError) {
      emit(CreateUserErrorState(onError.toString()));
    });
  }

  void resetPassword({required String email}) {
    emit(ResetPasswordLoadingState());
    FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: email,
    )
        .then((value) {
      emit(ResetPasswordSuccessState());
    }).catchError((error) {
      emit(ResetPasswordErrorState());
    });
  }

  String? selectedItem;

  void selected(String s) {
    selectedItem = s;
    emit(LoginSuccessState());
  }

  void verifyPasswordResetCode() {}

  void logout(context) {
    CacheHelper.clearData(key: 'id').then((value) {
      if (value) {
        toastMessage(message: value.toString());
      }
    });
  }

  var pickImage = ImagePicker();

  Future<void> pickProfileImage() async {
    final pickedFile = await pickImage.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
    } else {
      emit(PickProfileImageErrorState());
    }
  }

  void createNewUser({
    required String id,
    required String username,
    required String phoneNumber,
  }) {
    storage
        .ref()
        .child('users/${Uri.file(userImage!.path).pathSegments.last}')
        .putFile(userImage!)
        .then(
      (p0) {
        p0.ref.getDownloadURL().then((value) {
          UserModel user = UserModel(
              token: token,
              id: id,
              username: username,
              phone: phoneNumber,
              image: value);
          store.collection('users').doc(id).set(user.toMap()).then((value) {
            emit(CreateUserSuccessState());
          });
        }).catchError((onError) {
          emit(CreateUserErrorState(onError));
        });
        emit(UploadImageProfileSuccessState());
      },
    ).catchError((onError) {
      emit(UploadImageProfileErrorState(error: onError));
    });
  }
  void setStatusUser({required bool userActive}) {
    store
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({"userActive": userActive}).then((value) {});
  }
  bool sent = false;
  String verificationID = "1212";
  String phoneNumber = "";

  void loginWithPhone({required String phoneNumber}) async {
    emit(VerifyPhoneNumberLoadingState());
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        emit(VerificationCompletedState());
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(VerificationFailedState(e.message.toString()));
      },
      codeSent: (String verificationId, int? resendToken) {
        sent = true;
        verificationID = verificationId;
        emit(CodeSentState());
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        emit(CodeAutoRetrievalTimeoutState());
      },
    );
  }

  int start = 60;

  void startTimer() {
    Duration duration = const Duration(seconds: 1);
    Timer.periodic(duration, (timer) {
      start == 0 ? timer.cancel() : start--;
      emit(LoginErrorState("error"));
    });
  }
  String? userId;
  void verifyOTP({
    required String smsCode,
    required String username,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    emit(VerifyOTPLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: smsCode,
    );
    toastMessage(message: credential.smsCode.toString());
    await auth.signInWithCredential(credential).then((value) {
       userId = value.user!.uid;
      createNewUser(
        phoneNumber: phoneNumber,
        username: username,
        id: userId!,
      );
      emit(VerifyOTPSuccessState());
    }).catchError((onError) {
      emit(VerifyOTPErrorState(onError.toString()));
    });
  }
}
