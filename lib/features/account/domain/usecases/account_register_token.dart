import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountRegisterTokenUsecase {
  final AccountRepository repository;

  AccountRegisterTokenUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String token) async {
    return await repository.registerUser(token);
  }
}
