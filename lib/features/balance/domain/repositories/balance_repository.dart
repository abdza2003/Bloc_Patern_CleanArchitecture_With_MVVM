import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';

abstract class BalanceRepository {
  Future<Either<Failure, Unit>> addBalance(int childId,double balance,String accessToken);
  Future<Either<Failure, Unit>> storeWeeklyBalance(int childId,double balance,String accessToken);
}