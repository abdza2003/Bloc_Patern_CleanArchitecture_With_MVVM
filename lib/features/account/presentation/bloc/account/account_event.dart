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
  late final String classRoom;
  late final String division;

  AddChildEvent(this.name, this.userName, this.password, this.email,
      this.mobile, this.classRoom,this.division,this.accessToken);
}
class ChangePasswordEvent extends AccountEvent{
  late final String oldPass;
  late final String newPass;
  late final String confirmPass;
  late final String accessToken;


  ChangePasswordEvent(this.oldPass,this.newPass,this.confirmPass,this.accessToken);
}
class RegisterTokenEvent extends AccountEvent{
  final  String token;

  RegisterTokenEvent(this.token);
}
class GetNotificationEvent extends AccountEvent{
  late final List<String> accessTokens;

  GetNotificationEvent(this.accessTokens);
}
class ReadNotificationEvent extends AccountEvent{
  late final List<String> accessTokens;

  ReadNotificationEvent(this.accessTokens);
}
class DeleteNotificationEvent extends AccountEvent{
  final  int id;

  DeleteNotificationEvent(this.id);
}
class EditPhotoEvent extends AccountEvent{
  late final List<String> accessTokens;
  late final XFile image;

  EditPhotoEvent(this.image,this.accessTokens);
}