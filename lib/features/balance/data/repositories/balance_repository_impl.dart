import 'package:dartz/dartz.dart';
import 'package:school_cafteria/core/error/failures.dart';
import 'package:school_cafteria/features/balance/data/datasources/balance_remote_datasource.dart';
import 'package:school_cafteria/features/balance/data/models/payments_view_model.dart';
import 'package:school_cafteria/features/balance/domain/entities/payment.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/common_response.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/payments_view.dart';
import '../models/payment_model.dart';

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

  @override
  Future<Either<Failure, PaymentsView>> getPayments(List<int> studentIds,String? from,String? to) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getPayments(studentIds,from,to);
        if (commonResponse.status) {
          // List<PaymentModel> paymentModel = commonResponse.data
          //     .map<PaymentModel>((json) => PaymentModel.fromJson(json))
          //     .toList();
          PaymentsViewModel paymentsView=PaymentsViewModel.fromJson(commonResponse.data);
          return Right(paymentsView);
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
  Future<Either<Failure, Unit>> cancelBalance(int requestId, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.cancelBalance(requestId, accessToken);
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