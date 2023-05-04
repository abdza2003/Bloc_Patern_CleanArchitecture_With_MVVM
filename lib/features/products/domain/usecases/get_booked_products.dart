import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class GetBookedProductsUsecase {
  final ProductsRepository repository;

  GetBookedProductsUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(int childId ,String accessToken,int dayId ) async {
    return await repository.getBookedProducts(childId,accessToken,dayId);
  }
}
