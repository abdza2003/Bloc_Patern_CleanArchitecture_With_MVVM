import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class GetAllBannedProductsUsecase {
  final ProductsRepository repository;

  GetAllBannedProductsUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(int childId ,String accessToken) async {
    return await repository.getAllBannedProducts(childId,accessToken);
  }
}
