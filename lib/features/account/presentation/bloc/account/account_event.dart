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
class RefreshEvent extends AccountEvent{
  late final List<String> accessTokens;

  RefreshEvent(this.accessTokens);
}
class AddChildEvent extends AccountEvent{
  late final String name;
  late final String userName;
  late final String password;
  late final String email;
  late final String mobile;
  late final String accessToken;
  late final XFile? image;

  AddChildEvent(this.name, this.userName, this.password, this.email,
      this.mobile, this.image,this.accessToken);
}