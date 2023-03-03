import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/school_days.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/week_days.dart';

class GetSchoolDaysUsecase {
  final ProductsRepository repository;

  GetSchoolDaysUsecase(this.repository);

  Future<Either<Failure, WeekDays>> call(int childId,String accessToken) async {
    return await repository.getSchoolDays(childId,accessToken);
  }
}
