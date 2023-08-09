import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:school_cafteria/core/error/exceptions.dart';
import 'package:school_cafteria/features/account/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountLocalDataSource {
  Future<UserModel> getCachedUser();

  Future<Unit> cacheUser(UserModel userModel);
}

const CACHED_USER = "CACHED_USER";

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  AccountLocalDataSourceImpl({required this.sharedPreferences});

  late final SharedPreferences sharedPreferences;

  @override
  Future<Unit> cacheUser(UserModel userModel) {
    final userModelToJson = userModel.toJson();
    sharedPreferences.setString('token', userModel.accessToken!);
    sharedPreferences.setString(CACHED_USER, json.encode(userModelToJson));
    return Future.value(unit);
  }

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      final decodeJsonData = json.decode(jsonString);
      UserModel userModel = UserModel.fromJson(decodeJsonData);
      return Future.value(userModel);
    } else {
      throw EmptyCacheException();
    }
  }
}

//todo : json.encode() هي تحويل البيانات الى نص 
//todo : json.decode() هي ارجاع النص الى شكله الاصلي