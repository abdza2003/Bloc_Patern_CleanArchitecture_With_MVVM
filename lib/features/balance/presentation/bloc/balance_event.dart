part of 'balance_bloc.dart';

@immutable
abstract class BalanceEvent {}
class AddBalanceEvent extends BalanceEvent{
  late final double balance;
  late final int childId;
  late final String accessToken;

  AddBalanceEvent(this.balance, this.childId, this.accessToken);
}
class StoreWeeklyBalanceEvent extends BalanceEvent{
  late final double balance;
  late final int childId;
  late final String accessToken;

  StoreWeeklyBalanceEvent(this.balance, this.childId, this.accessToken);
}