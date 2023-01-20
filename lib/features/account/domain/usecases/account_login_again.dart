import 'package:school_cafteria/features/account/domain/entities/user.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class AccountLoginAgainUsecase {
  final AccountRepository repository;

  AccountLoginAgainUsecase(this.repository);

  Future<Either<Failure, User>> call(String userOrEmail,String password) async {
    return await repository.loginAgain(userOrEmail, password);
  }
}
