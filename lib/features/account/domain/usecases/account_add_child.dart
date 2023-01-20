import '../entities/child.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountAddChildUsecase {
  final AccountRepository repository;

  AccountAddChildUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Child child) async {
    return await repository.addChild(child);
  }
}
