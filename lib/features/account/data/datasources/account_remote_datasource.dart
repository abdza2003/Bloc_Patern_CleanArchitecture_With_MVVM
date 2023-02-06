import 'dart:io';

import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api.dart';
import '../../../../core/network/common_response.dart';

abstract class AccountRemoteDataSource {
  Future<dynamic> login(String userOrEmail,String password,bool isEmail);
  Future<dynamic> logout();
  Future<dynamic> addChild(String name,String userName,String password,String email,String mobile,XFile? image,String accessToken);
}
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource
{
  @override
  Future<dynamic> addChild(String name,String userName,String password,String email,String mobile,XFile? image, String accessToken) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name']=name;
    data['user_name']=userName;
    data['password']=password;
    data['email']=email;
    data['mobile']=mobile;
    if (image==null)
      {
        return Network().postAuthData(data,"/user/store-student",accessToken).then((dynamic response) {
          return CommonResponse<dynamic>.fromJson(response);
        });
      }
    else {
      return Network().postAuthImage("/user/store-student",data,File(image.path),image.name,"image",accessToken).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
    }
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

