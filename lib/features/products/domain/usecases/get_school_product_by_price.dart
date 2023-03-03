import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class GetSchoolProductsByPriceUsecase {
  final ProductsRepository repository;

  GetSchoolProductsByPriceUsecase(this.repository);

  Future<Either<Failure, SchoolProducts>> call(int childId,String accessToken, double? maxPrice ) async {
    return await repository.getSchoolProductsByPrice(childId,accessToken,maxPrice);
  }
}
