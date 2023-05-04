import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/balance/domain/entities/payment.dart';
import '../../../../core/error/failures.dart';
import '../entities/payments_view.dart';

abstract class BalanceRepository {
  Future<Either<Failure, Unit>> addBalance(int childId,double balance,String accessToken);
  Future<Either<Failure, Unit>> cancelBalance(int requestId,String accessToken);
  Future<Either<Failure, PaymentsView>> getPayments(List<int> studentIds,String? from,String? to);
  Future<Either<Failure, Unit>> storeWeeklyBalance(int childId,double balance,String accessToken);
}