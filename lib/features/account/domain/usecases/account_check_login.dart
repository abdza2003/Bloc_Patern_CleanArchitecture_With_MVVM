import 'package:school_cafteria/features/account/domain/entities/user.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class AccountCheckLoginUsecase {
  final AccountRepository repository;

  AccountCheckLoginUsecase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.checkLogin();
  }
}
