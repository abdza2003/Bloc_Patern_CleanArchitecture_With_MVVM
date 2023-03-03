import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class GetDayProductsUsecase {
  final ProductsRepository repository;

  GetDayProductsUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(int childId,String accessToken ,int dayId) async {
    return await repository.getDayProducts(childId,accessToken,dayId);
  }
}
