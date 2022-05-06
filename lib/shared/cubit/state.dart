abstract class ChatStates {}

class AppInitialState extends ChatStates {}

//btn nav state
class BottomNavigationState extends ChatStates {}

//AppChangeBottomSheetState
class AppChangeBottomSheetState extends ChatStates {}

class Checked extends ChatStates {}

//get user data state
class GetUserDataLoading extends ChatStates {}

class GetUserDataSuccess extends ChatStates {}

class GetUserDataError extends ChatStates {}

//send message state
class SendMessageLoading extends ChatStates {}

class SendMessageSuccess extends ChatStates {}

class SendMessageError extends ChatStates {}

//get messages state
class GetMessagesLoading extends ChatStates {}

class GetMessagesSuccess extends ChatStates {}

class GetMessagesError extends ChatStates {}

//get last message state
class GetLastMessageLoading extends ChatStates {}

class GetLastMessageSuccess extends ChatStates {}

class GetLastMessageError extends ChatStates {}

//get users state
class GetUsersLoading extends ChatStates {}

class GetUsersSuccess extends ChatStates {}

class GetUsersError extends ChatStates {
  String error;

  GetUsersError(this.error);
}

//delete messages state
class DeleteMessageSuccess extends ChatStates {}

class DeleteMessageError extends ChatStates {}

//create group state
class CreateGroupLoading extends ChatStates {}

class CreateGroupSuccess extends ChatStates {}

class CreateGroupError extends ChatStates {}

//add users to group state
class AddUsersToGroupLoading extends ChatStates {}

class AddUsersToGroupSuccess extends ChatStates {}

class AddUsersToGroupError extends ChatStates {}

//upload image state
class UploadImageLoading extends ChatStates {}

class UploadImageSuccess extends ChatStates {}

class UploadImageError extends ChatStates {}

//get contacts state
class GetContactsLoading extends ChatStates {}

class GetContactsSuccess extends ChatStates {}

class GetContactsError extends ChatStates {}

//send notification state
class SendNotificationLoadingState extends ChatStates {}

class SendNotificationSuccessState extends ChatStates {}

class SendNotificationErrorState extends ChatStates {}

//get active user state
class GetActiveUsersSuccess extends ChatStates {}

class GetOnlineUsersLoading extends ChatStates {}

//get groups state
class GetGroupsSuccessState extends ChatStates {}

class GetGroupsLoadingState extends ChatStates {}

class GetGroupsErrorState extends ChatStates {
  String error;

  GetGroupsErrorState(this.error);
}

//pick image state
class PickImageSuccessState extends ChatStates {}

class PickImageErrorState extends ChatStates {}

//upload image state
class UploadImageErrorState extends ChatStates {
  UploadImageErrorState({required String error});
}

class UploadImageSuccessState extends ChatStates {}

//pick multi images
class PickMultiImageSuccess extends ChatStates {}

class PickMultiImageLoading extends ChatStates {}

class PickMultiImageError extends ChatStates {
  String error;

  PickMultiImageError(this.error);
}

//clear  images
class ClearImagesSuccess extends ChatStates {}

//upload multi images
class UploadMultiImageSuccess extends ChatStates {}

class UploadMultiImageLoading extends ChatStates {}

class UploadMultiImageError extends ChatStates {
  String error;

  UploadMultiImageError(this.error);
}
