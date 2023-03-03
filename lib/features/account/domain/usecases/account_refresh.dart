import 'package:school_cafteria/features/account/domain/entities/user.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class AccountRefreshUsecase {
  final AccountRepository repository;

  AccountRefreshUsecase(this.repository);

  Future<Either<Failure, User>> call(List<String> accessTokens) async {
    return await repository.refresh(accessTokens);
  }
}
