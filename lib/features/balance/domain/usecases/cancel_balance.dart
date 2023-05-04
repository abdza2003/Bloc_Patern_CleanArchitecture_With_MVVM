import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';
import '../../../../core/error/failures.dart';

class CancelBalanceUsecase {
  final BalanceRepository repository;

  CancelBalanceUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int requestId,String accessToken) async {
    return await repository.cancelBalance(requestId, accessToken);
  }
}
