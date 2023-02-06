import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/selected_products_model.dart';
import '../entities/products.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getAllBannedProducts(int childId,String accessToken);
  Future<Either<Failure, SchoolProducts>> getAllSchoolProducts(int childId,String accessToken);
  Future<Either<Failure, Unit>> deleteBannedProducts(int productId,int childId,String accessToken);
  Future<Either<Failure, Unit>> storeBannedProducts(SelectedProductsModel selectedProducts,String accessToken);//Food food);
}
