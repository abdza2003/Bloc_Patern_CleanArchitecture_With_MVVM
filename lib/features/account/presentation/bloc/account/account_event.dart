part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}
class LoginEvent extends AccountEvent{
  final  String usernameOrEmail;
  final  String password;
  final  bool isEmail;

  LoginEvent(this.usernameOrEmail, this.password, this.isEmail);
}
class LogoutEvent extends AccountEvent{}
class CheckLoginEvent extends AccountEvent{}
class SecondLoginEvent extends AccountEvent{
  final  String usernameOrEmail;
  final  String password;
  final  bool isEmail;

  SecondLoginEvent(this.usernameOrEmail, this.password, this.isEmail);
}
class AddChildEvent extends AccountEvent{
  late final Child child;

  AddChildEvent(this.child);
}