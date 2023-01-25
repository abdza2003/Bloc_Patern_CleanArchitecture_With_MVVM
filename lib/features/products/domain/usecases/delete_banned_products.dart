import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteBannedProductsUsecase {
  final ProductsRepository repository;

  DeleteBannedProductsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int productId, int childId ) async {
    return await repository.deleteBannedProducts(productId,childId);
  }
}
