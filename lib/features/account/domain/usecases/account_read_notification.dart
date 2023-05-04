import '../entities/notification.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountReadNotificationUsecase {
  final AccountRepository repository;

  AccountReadNotificationUsecase(this.repository);

  Future<Either<Failure, Unit>> call(List<String> accessTokens) async {
    return await repository.readNotifications(accessTokens);
  }
}
