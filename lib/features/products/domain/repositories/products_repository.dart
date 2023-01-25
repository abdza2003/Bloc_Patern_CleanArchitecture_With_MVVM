import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/products.dart';
import '../entities/selected_products.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getAllBannedProducts(int childId);
  Future<Either<Failure, List<Product>>> getAllSchoolProducts(int childId);
  Future<Either<Failure, Unit>> deleteBannedProducts(int productId,int childId);
  Future<Either<Failure, Unit>> storeBannedProducts(SelectedProducts selectedProducts);//Food food);
}
