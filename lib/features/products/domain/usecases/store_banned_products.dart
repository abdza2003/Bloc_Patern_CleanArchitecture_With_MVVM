import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/selected_products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class StoreBannedProductsUsecase {
  final ProductsRepository repository;

  StoreBannedProductsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(SelectedProducts selectedProducts) async {
    return await repository.storeBannedProducts(selectedProducts);
  }
}
