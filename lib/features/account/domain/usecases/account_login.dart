import 'package:school_cafteria/features/account/domain/entities/user.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class AccountLoginUsecase {
  final AccountRepository repository;

  AccountLoginUsecase(this.repository);

  Future<Either<Failure, User>> call(String usernameOrEmail,String password,bool isEmail) async {
    return await repository.login(usernameOrEmail,password,isEmail);
  }
}
