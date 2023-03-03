import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/school_days.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import 'package:school_cafteria/features/products/domain/entities/week_days.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/selected_products_model.dart';
import '../entities/products.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getAllBannedProducts(int childId,String accessToken);
  Future<Either<Failure, SchoolProducts>> getAllSchoolProducts(int childId,String accessToken);
  Future<Either<Failure, Unit>> deleteBannedProducts(int productId,int childId,String accessToken);
  Future<Either<Failure, Unit>> storeBannedProducts(SelectedProductsModel selectedProducts,String accessToken);

  Future<Either<Failure, WeekDays>> getSchoolDays(int childId,String accessToken);
  Future<Either<Failure, SchoolProducts>> getSchoolProductsByPrice(int childId,String accessToken,double? maxPrice);
  Future<Either<Failure, List<Product>>> getDayProducts(int childId,String accessToken, int dayId);
  Future<Either<Failure, Unit>> deleteDayProduct(int productId,int childId,String accessToken,int dayId);
  Future<Either<Failure, Unit>> storeDayProducts(SelectedProductsModel selectedProducts,String accessToken);
  Future<Either<Failure, Unit>> storeWeekProducts(SelectedProductsModel selectedProducts,String accessToken);

}
