import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';
import '../../../../core/error/failures.dart';

class StoreWeeklyBalanceUsecase {
  final BalanceRepository repository;

  StoreWeeklyBalanceUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int childId,double balance,String accessToken) async {
    return await repository.storeWeeklyBalance(childId, balance, accessToken);
  }
}
