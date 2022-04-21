abstract class UserStates {}

class UserInitialState extends UserStates {}

//Create user state
class CreateUserLoadingState extends UserStates {}

class CreateUserSuccessState extends UserStates {}

class CreateUserErrorState extends UserStates {
  String error;

  CreateUserErrorState(this.error);
}

//Reset password state
class ResetPasswordLoadingState extends UserStates {}

class ResetPasswordSuccessState extends UserStates {}

class ResetPasswordErrorState extends UserStates {}

//Login state

class LoginLoadingState extends UserStates {}

class LoginSuccessState extends UserStates {}

class LoginErrorState extends UserStates {
  String error;

  LoginErrorState(this.error);
}

class VerifyPhoneNumberLoadingState extends UserStates {}

class VerifyPhoneNumberSuccessState extends UserStates {}

class VerifyPhoneNumberErrorState extends UserStates {}

class CodeAutoRetrievalTimeoutState extends UserStates {}

class CodeSentState extends UserStates {}

class VerificationCompletedState extends UserStates {}

class VerificationFailedState extends UserStates {
  String error;

  VerificationFailedState(this.error);
}

class VerifyOTPLoadingState extends UserStates {}

class VerifyOTPSuccessState extends UserStates {}

class VerifyOTPErrorState extends UserStates {
  String error;

  VerifyOTPErrorState(this.error);
}

class VerifyOTPNotMatchState extends UserStates {
  String error;

  VerifyOTPNotMatchState(this.error);
}

//pick image state
class PickProfileImageSuccessState extends UserStates {}

class PickProfileImageErrorState extends UserStates {}
//upload image state

class UploadImageProfileErrorState extends UserStates {
  UploadImageProfileErrorState({required String error});
}

class UploadImageProfileSuccessState extends UserStates {}
