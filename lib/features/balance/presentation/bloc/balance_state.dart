part of 'balance_bloc.dart';

@immutable
abstract class BalanceState {}

class BalanceInitial extends BalanceState {}
class LoadingState extends BalanceState{}
class ErrorMsgState extends BalanceState{
  late final String message;

  ErrorMsgState({required this.message});

}
class SuccessMsgState extends BalanceState{
  late final String message;

  SuccessMsgState({required this.message});

}