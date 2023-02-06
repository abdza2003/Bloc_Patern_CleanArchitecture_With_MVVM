import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class GetAllSchoolProductsUsecase {
  final ProductsRepository repository;

  GetAllSchoolProductsUsecase(this.repository);

  Future<Either<Failure, SchoolProducts>> call(int childId,String accessToken ) async {
    return await repository.getAllSchoolProducts(childId,accessToken);
  }
}
