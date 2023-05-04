import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';
import '../entities/payments_view.dart';

class GetPaymentsUsecase {
  final BalanceRepository repository;

  GetPaymentsUsecase(this.repository);

  Future<Either<Failure, PaymentsView>> call(List<int> studentIds,String? from,String? to) async {
    return await repository.getPayments(studentIds,from,to);
  }
}
