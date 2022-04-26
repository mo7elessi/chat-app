abstract class ChatStates {}

class AppInitialState extends ChatStates {}

//btn nav state
class BottomNavigationState extends ChatStates {}

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

class GetGroupsErrorState extends ChatStates {
  String error;

  GetGroupsErrorState(this.error);
}

