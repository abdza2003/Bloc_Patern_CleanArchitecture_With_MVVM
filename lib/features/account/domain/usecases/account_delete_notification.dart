import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountDeleteNotificationUsecase {
  final AccountRepository repository;

  AccountDeleteNotificationUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteNotification(id);
  }
}
