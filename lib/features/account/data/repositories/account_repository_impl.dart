import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_cafteria/core/error/failures.dart';
import 'package:school_cafteria/features/account/data/models/notification_model.dart';
import 'package:school_cafteria/features/account/data/models/user_model.dart';
import 'package:school_cafteria/features/account/domain/entities/notification.dart';
import 'package:school_cafteria/features/account/domain/entities/user.dart';
import 'package:school_cafteria/features/account/domain/repositories/account_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/common_response.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/account_local_datasource.dart';
import '../datasources/account_remote_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  late final AccountRemoteDataSource remoteDataSource;
  late final AccountLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;

  AccountRepositoryImpl(
      {required this.remoteDataSource,
      required this.networkInfo,
      required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addChild(
      String name,
      String userName,
      String password,
      String email,
      String mobile,
      String classRoom,
      String division,
      String accessToken) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse loginResponse;
        loginResponse = await remoteDataSource.addChild(
            name, userName, password, email, mobile, classRoom,division, accessToken);
        if (loginResponse.status) {
          return const Right(unit);
        } else {
          return Left(WrongRegistrationInformationFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, User>> login(
      String userOrEmail, String password, bool isEmail) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse loginResponse;
        loginResponse =
            await remoteDataSource.login(userOrEmail, password, isEmail);
        if (loginResponse.status) {
          UserModel userModel = UserModel.fromJson(loginResponse.data);
          userModel.school!.accessToken = userModel.accessToken;
          userModel.schools = [];
          userModel.schools!.add(userModel.school!);
          if (userModel.childern != null) {
            for (var v = 0; v < userModel.childern!.length; v++) {
              userModel.childern![v].accessTokenParent = userModel.accessToken;
            }
          }
          await localDataSource.cacheUser(userModel);
          return Right(userModel);
        } else {
          return Left(WrongLoginInformationFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    if (await networkInfo.isConnected) {
      CommonResponse logoutResponse;
      logoutResponse = await remoteDataSource.logout();
      if (logoutResponse.status) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.clear();
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, User>> checkLogin() async {
    try {
      UserModel userModel = await localDataSource.getCachedUser();
      return Right(userModel);
    } on EmptyCacheException {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> loginAgain(
      String userOrEmail, String password, bool isEmail) async {
    if (await networkInfo.isConnected) {
      try {
        UserModel user = await localDataSource.getCachedUser();
        CommonResponse loginResponse;
        loginResponse =
            await remoteDataSource.login(userOrEmail, password, isEmail);
        if (loginResponse.status) {
          UserModel userModel = UserModel.fromJson(loginResponse.data);
          userModel.school!.accessToken = userModel.accessToken;
          if (userModel.childern != null) {
            for (var child in userModel.childern!) {
              child.accessTokenParent = userModel.accessToken;
              if (user.childern == null ||
                  !user.childern!.any((element) => element.id == child.id)) {
                user.childern?.add(child);
              }
            }
            user.schools!.add(userModel.school!);
          }
          await localDataSource.cacheUser(user);
          return Right(user);
        } else {
          return Left(WrongLoginInformationFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, User>> refresh(List<String> accessTokens) async {
    if (await networkInfo.isConnected) {
      try {
        UserModel user = await localDataSource.getCachedUser();
        user.childern = [];
        for (var login in accessTokens) {
          CommonResponse loginResponse;
          loginResponse = await remoteDataSource.refresh(login);
          UserModel userModel = UserModel.fromJson(loginResponse.data);
          userModel.school!.accessToken = userModel.accessToken;
          if (userModel.childern != null) {
            for (var child in userModel.childern!) {
              child.accessTokenParent = login;
              user.childern!.add(child);
            }
          }
        }
        localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> registerUser(String token) async {
    if (await networkInfo.isConnected) {
      CommonResponse logoutResponse;
      logoutResponse = await remoteDataSource.registerToken(token);
      if (logoutResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(String oldPass, String newPass, String confirmPass, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse logoutResponse;
      logoutResponse = await remoteDataSource.changePassword(oldPass, newPass, confirmPass, accessToken);
      if (logoutResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<NotificationMassage>>> getNotifications(List<String> accessTokens) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getNotifications(accessTokens);
        if (commonResponse.status) {
          List<NotificationMassageModel> notifications = commonResponse.data
              .map<NotificationMassageModel>((json) => NotificationMassageModel.fromJson(json))
              .toList();
          return Right(notifications);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> readNotifications(List<String> accessTokens) async {
    if (await networkInfo.isConnected) {
      CommonResponse logoutResponse;
      logoutResponse = await remoteDataSource.readNotifications(accessTokens);
      if (logoutResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editPhoto(XFile? image, List<String> accessTokens) async {
    if (await networkInfo.isConnected) {
      CommonResponse editResponse;
      editResponse = await remoteDataSource.editPhoto(image!, accessTokens);
      if (editResponse.status) {
        UserModel user = await localDataSource.getCachedUser();
        Map<String,dynamic> map=  editResponse.data;
        String image= map.entries.firstWhere((element) => element.key=="image").value;
        user.image=image;
        localDataSource.cacheUser(user);
        return  Right(image);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(int id) async {
    if (await networkInfo.isConnected) {
      CommonResponse logoutResponse;
      logoutResponse = await remoteDataSource.deleteNotification(id);
      if (logoutResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
