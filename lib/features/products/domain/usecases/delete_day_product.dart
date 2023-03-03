import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteDayProductUsecase {
  final ProductsRepository repository;

  DeleteDayProductUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int productId, int childId,String accessToken,int dayId ) async {
    return await repository.deleteDayProduct(productId,childId,accessToken,dayId);
  }
}