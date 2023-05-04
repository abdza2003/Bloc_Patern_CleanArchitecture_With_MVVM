import '../entities/notification.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountGetNotificationUsecase {
  final AccountRepository repository;

  AccountGetNotificationUsecase(this.repository);

  Future<Either<Failure, List<NotificationMassage>>> call(List<String> accessTokens) async {
    return await repository.getNotifications(accessTokens);
  }
}
