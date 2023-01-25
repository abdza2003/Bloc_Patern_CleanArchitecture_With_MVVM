import 'package:dartz/dartz.dart';
import 'package:school_cafteria/core/error/failures.dart';
import 'package:school_cafteria/features/account/data/models/user_model.dart';
import 'package:school_cafteria/features/account/domain/entities/child.dart';
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
  Future<Either<Failure, Unit>> addChild(Child child) {
    // TODO: implement addChild
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> login(
      String userOrEmail, String password,bool isEmail) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse loginResponse;
        loginResponse = await remoteDataSource.login(userOrEmail, password,isEmail);
        if (loginResponse.status) {
          UserModel userModel = UserModel.fromJson(loginResponse.data);
          userModel.schools=[];
          userModel.schools!.add(userModel.school!);
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
        SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
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
      String userOrEmail, String password,bool isEmail) async {
    if (await networkInfo.isConnected) {
      try {
        UserModel user = await localDataSource.getCachedUser();
        CommonResponse loginResponse;
        loginResponse = await remoteDataSource.login(userOrEmail, password,isEmail);
        if (loginResponse.status) {
          UserModel userModel = UserModel.fromJson(loginResponse.data);
          if (userModel.childern != null) {
            for (var child in userModel.childern!) {
              child.accessTokenParent = userModel.accessToken;
              if (user.childern == null || !user.childern!.any((element) => element.id==child.id)) {
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
}
