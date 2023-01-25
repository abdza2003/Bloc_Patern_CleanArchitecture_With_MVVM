import 'package:dartz/dartz.dart';
import 'package:school_cafteria/core/error/failures.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/entities/selected_products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';

import '../../../../core/network/network_info.dart';
import '../datasources/products_remote_datasource.dart';

class ProductRepositoryImpl implements ProductsRepository {
  late final ProductsRemoteDataSource remoteDataSource;
  //late final ProductsLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Unit>> deleteBannedProducts(int productId, int childId) {
    // TODO: implement deleteBannedProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getAllBannedProducts(int childId) {
    // TODO: implement getAllBannedProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getAllSchoolProducts(int childId) {
    // TODO: implement getAllSchoolProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> storeBannedProducts(SelectedProducts selectedProducts) {
    // TODO: implement storeBannedProducts
    throw UnimplementedError();
  }
}
