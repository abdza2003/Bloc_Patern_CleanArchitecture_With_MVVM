import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountChangePasswordUsecase {
  final AccountRepository repository;

  AccountChangePasswordUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String oldPass,String newPass,String confirmPass,String accessToken) async {
    return await repository.changePassword(oldPass, newPass, confirmPass,accessToken);
  }
}
