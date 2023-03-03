import 'package:dartz/dartz.dart';
import 'package:school_cafteria/core/error/failures.dart';
import 'package:school_cafteria/features/products/data/models/school_days_model.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';
import 'package:school_cafteria/features/products/domain/entities/school_days.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/common_response.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/week_days.dart';
import '../datasources/products_remote_datasource.dart';
import '../models/products_model.dart';
import '../models/school_products_model.dart';
import '../models/selected_products_model.dart';
import '../models/weekly_days_model.dart';


class ProductRepositoryImpl implements ProductsRepository {
  late final ProductsRemoteDataSource remoteDataSource;

  //late final ProductsLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;
  ProductRepositoryImpl({required this.remoteDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> deleteBannedProducts(
      int productId, int childId, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.deleteBannedProducts(
          productId, childId, accessToken);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllBannedProducts(
      int childId, String accessToken) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getAllBannedProducts(childId, accessToken);
        if (commonResponse.status) {
          List<ProductModel> productsModel = commonResponse.data
              .map<ProductModel>((json) => ProductModel.fromJson(json))
              .toList();
          return Right(productsModel);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, SchoolProducts>> getAllSchoolProducts(
      int childId, String accessToken) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getAllSchoolProducts(childId, accessToken);
        if (commonResponse.status) {
          SchoolProductModel schoolProductsModel = SchoolProductModel.fromJson(commonResponse.data);
          for (var v = 0; v<schoolProductsModel.restaurant!.length; v++) {
            schoolProductsModel.restaurant![v].isMarket="false";
          }
          return Right(schoolProductsModel);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> storeBannedProducts(
      SelectedProductsModel selectedProducts, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.storeBannedProducts(
          selectedProducts, accessToken);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDayProduct(int productId, int childId, String accessToken, int dayId) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.deleteDayProduct(
          productId, childId, accessToken,dayId);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, SchoolProducts>> getSchoolProductsByPrice(int childId, String accessToken, double? maxPrice) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getSchoolProductsByPrice(childId, accessToken,maxPrice);
        if (commonResponse.status) {
          SchoolProductModel schoolProductsModel = SchoolProductModel.fromJson(commonResponse.data);
          for (var v = 0; v<schoolProductsModel.restaurant!.length; v++) {
            schoolProductsModel.restaurant![v].isMarket="false";
          }
          return Right(schoolProductsModel);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getDayProducts(int childId, String accessToken, int dayId) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getDayProducts(childId, accessToken,dayId);
        if (commonResponse.status) {
          List<ProductModel> productsModel = commonResponse.data
              .map<ProductModel>((json) => ProductModel.fromJson(json))
              .toList();
          return Right(productsModel);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, WeekDays>> getSchoolDays(int childId, String accessToken) async {
    if (await networkInfo.isConnected) {
      try {
        CommonResponse commonResponse;
        commonResponse =
            await remoteDataSource.getSchoolDays(childId, accessToken);
        if (commonResponse.status) {
          WeekDays weekDays = WeekDaysModel.fromJson(commonResponse.data);
          return Right(weekDays);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> storeDayProducts(SelectedProductsModel selectedProducts, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.storeDayProducts(
          selectedProducts, accessToken);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> storeWeekProducts(SelectedProductsModel selectedProducts, String accessToken) async {
    if (await networkInfo.isConnected) {
      CommonResponse commonResponse;
      commonResponse = await remoteDataSource.storeWeekProducts(
          selectedProducts, accessToken);
      if (commonResponse.status) {
        return const Right(unit);
      } else {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

}
