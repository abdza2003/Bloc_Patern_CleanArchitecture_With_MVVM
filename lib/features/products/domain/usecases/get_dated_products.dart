import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class GetDatedProductsUsecase {
  final ProductsRepository repository;

  GetDatedProductsUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(String accessToken,int dayId) async {
    return await repository.getDatedProducts(accessToken,dayId);
  }
}
