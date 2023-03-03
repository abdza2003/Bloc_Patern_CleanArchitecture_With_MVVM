import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';
import '../../../../core/error/failures.dart';

class AddBalanceUsecase {
  final BalanceRepository repository;

  AddBalanceUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int childId,double balance,String accessToken) async {
    return await repository.addBalance(childId, balance, accessToken);
  }
}
