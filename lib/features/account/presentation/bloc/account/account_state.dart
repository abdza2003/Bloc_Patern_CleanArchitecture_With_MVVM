part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}
class LoadingState extends AccountState{}
class LoggedOutState extends AccountState{}
class LoggedInState extends AccountState{
  late final User user;

  LoggedInState({required this.user});

}
class ErrorMsgState extends AccountState{
   late final String message;

   ErrorMsgState({required this.message});

}
class SuccessMsgState extends AccountState{
   late final String message;

   SuccessMsgState({required this.message});

}
class SuccessChangePasswordState extends AccountState{
   late final String message;

   SuccessChangePasswordState({required this.message});

}
class SuccessEditPhotoState extends AccountState{
   late final String message;
   late final String image;

   SuccessEditPhotoState({required this.message,required this.image});

}
class SuccessReadNotificationState extends AccountState{
   late final String message;

   SuccessReadNotificationState({required this.message});

}
class SuccessDeleteNotificationState extends AccountState{
   late final String message;

   SuccessDeleteNotificationState({required this.message});

}
class LoadedNotification extends AccountState
{
  late final List<NotificationMassage> notifications;

  LoadedNotification({required this.notifications});
}

//class AnotherLoginState extends AccountState{}
