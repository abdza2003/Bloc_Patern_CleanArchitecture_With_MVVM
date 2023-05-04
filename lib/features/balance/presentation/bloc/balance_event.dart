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
class GetPaymentsEvent extends BalanceEvent{
  late final List<int> studentIds;
  late final String? from;
  late final String? to;
  GetPaymentsEvent(this.studentIds,this.from,this.to);
}
class CancelBalanceEvent extends BalanceEvent{
  late final int requestId;
  late final String accessToken;

  CancelBalanceEvent(this.requestId, this.accessToken);
}