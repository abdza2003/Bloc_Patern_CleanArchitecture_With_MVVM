import 'package:school_cafteria/features/products/data/models/selected_products_model.dart';
import 'package:school_cafteria/features/products/domain/entities/selected_products.dart';

abstract class ProductsRemoteDataSource {
  Future<dynamic> getAllBannedProducts(int childId);
  Future<dynamic> getAllSchoolProducts(int childId);
  Future<dynamic> storeBannedProducts(SelectedProductsModel selectedProductsModel);
  Future<dynamic> deleteBannedProducts(int productId, int childId);
}
class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  @override
  Future deleteBannedProducts(int productId, int childId) {
    // TODO: implement deleteBannedProducts
    throw UnimplementedError();
  }

  @override
  Future getAllBannedProducts(int childId) {
    // TODO: implement getAllBannedProducts
    throw UnimplementedError();
  }

  @override
  Future getAllSchoolProducts(int childId) {
    // TODO: implement getAllSchoolProducts
    throw UnimplementedError();
  }

  @override
  Future storeBannedProducts(SelectedProductsModel selectedProductsModel) {
    // TODO: implement storeBannedProducts
    throw UnimplementedError();
  }
  

}