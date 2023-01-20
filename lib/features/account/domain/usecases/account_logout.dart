import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountLogoutUsecase {
  final AccountRepository repository;

  AccountLogoutUsecase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logout();
  }
}
