part of 'balance_bloc.dart';

@immutable
abstract class BalanceState {}

class BalanceInitial extends BalanceState {}
class LoadingState extends BalanceState{}
class LoadedPaymentsState extends BalanceState {
  final PaymentsView payments;

  LoadedPaymentsState({ required this.payments});

}
class ErrorMsgState extends BalanceState{
  late final String message;

  ErrorMsgState({required this.message});

}
class SuccessMsgState extends BalanceState{
  late final String message;

  SuccessMsgState({required this.message});

}
class SuccessCancelMsgState extends BalanceState{
  late final String message;

  SuccessCancelMsgState({required this.message});

}