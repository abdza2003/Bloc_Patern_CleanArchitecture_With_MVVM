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
//class AnotherLoginState extends AccountState{}
