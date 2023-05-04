import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api.dart';
import '../../../../core/network/common_response.dart';

abstract class AccountRemoteDataSource {
  Future<dynamic> login(String userOrEmail,String password,bool isEmail);
  Future<dynamic> logout();
  Future<dynamic> refresh(String accessToken);
  Future<dynamic> addChild(String name,String userName,String password,String email,String mobile,String classRoom, String division,String accessToken);
  Future<dynamic> registerToken(String token);
  Future<dynamic> changePassword(String oldPass,String newPass,String confirmPass,String accessToken);
  Future<dynamic> getNotifications(List<String> accessTokens);
  Future<dynamic> readNotifications(List<String> accessTokens);
  Future<dynamic> deleteNotification(int id);
  Future<dynamic> editPhoto(XFile image,List<String> accessTokens);

}
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource
{
  @override
  Future<dynamic> addChild(String name,String userName,String password,String email,String mobile,String classRoom, String division, String accessToken) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name']=name;
    data['user_name']=userName;
    data['password']=password;
    data['email']=email;
    data['mobile']=mobile;
    data['class_room']=classRoom;
    data['division']=division;

        return Network().postAuthData(data,"/user/store-student",accessToken).then((dynamic response) {
          return CommonResponse<dynamic>.fromJson(response);
        });
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

  @override
  Future refresh(String accessToken) {
    return Network().getAuthData("/user/get-user-children",accessToken).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future registerToken(String token) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_token']=token;
    return Network().postAuthData(data,"/user/store-device_token",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future changePassword(String oldPass, String newPass, String confirmPass,String accessToken) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['old_password']=oldPass;
    data['new_password']=newPass;
    data['confirm_password']=confirmPass;
    return Network().postAuthData(data,"/user/change-password",accessToken).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getNotifications(List<String> accessTokens) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokens'] = accessTokens.map((v) => v.toString()).toList();
    return Network().postAuthData(data,"/user/get-notifications",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future readNotifications(List<String> accessTokens) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokens'] = accessTokens.map((v) => v.toString()).toList();
    return Network().postAuthData(data,"/user/read-notifications",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future editPhoto(XFile image, List<String> accessTokens) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokens[]'] = accessTokens.map((v) => v.toString()).toList();
    return Network().postAuthImage("/user/edit-photo",data,File(image.path),image.name,"image",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future deleteNotification(int id) {
    return Network().getAuthData("/user/delete-notification/$id",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

}

