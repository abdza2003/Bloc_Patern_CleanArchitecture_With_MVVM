part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}
class LoginEvent extends AccountEvent{
  final  String usernameOrEmail;
  final  String password;

  LoginEvent(this.usernameOrEmail, this.password);
}
class LogoutEvent extends AccountEvent{}
class CheckLoginEvent extends AccountEvent{}
class SecondLoginEvent extends AccountEvent{
  final  String usernameOrEmail;
  final  String password;

  SecondLoginEvent(this.usernameOrEmail, this.password);
}
class AddChildEvent extends AccountEvent{
  late final Child child;

  AddChildEvent(this.child);
}