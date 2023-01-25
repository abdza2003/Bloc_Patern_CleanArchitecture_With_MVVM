import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api.dart';
import '../../../../core/network/common_response.dart';
import '../../domain/entities/child.dart';

abstract class AccountRemoteDataSource {
  Future<dynamic> login(String userOrEmail,String password,bool isEmail);
  Future<dynamic> logout();
  Future<dynamic> addChild(Child child);
}
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource
{
  @override
  Future<dynamic> addChild(Child child) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<dynamic> login(String userOrEmail, String password,bool isEmail) {
    final Map<String, dynamic> data = <String, dynamic>{};
    isEmail?data['email'] = userOrEmail:data['user_name'] = userOrEmail;
    data['password'] = password;
    return Network().postData(data, "/user/login").then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future<dynamic> logout() async {
    return Network().postAuthData(null,"/user/logout",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

}

