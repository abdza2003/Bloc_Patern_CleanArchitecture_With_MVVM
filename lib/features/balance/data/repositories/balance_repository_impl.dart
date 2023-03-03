import 'package:dartz/dartz.dart';
import 'package:school_cafteria/core/error/failures.dart';
import 'package:school_cafteria/features/balance/data/datasources/balance_remote_datasource.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';

import '../../../../core/network/common_response.dart';
import '../../../../core/network/network_info.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  late final BalanceRemoteDataSource remoteDataSource;

  //late final ProductsLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;
  BalanceRepositoryImpl({required this.remoteDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> addBalance(int childId, double balance, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.addBalance(childId, balance, accessToken);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> storeWeeklyBalance(int childId, double balance, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.storeWeeklyBalance(childId, balance, accessToken);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}