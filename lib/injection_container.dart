import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:school_cafteria/features/balance/data/datasources/balance_remote_datasource.dart';
import 'package:school_cafteria/features/balance/data/repositories/balance_repository_impl.dart';
import 'package:school_cafteria/features/balance/domain/repositories/balance_repository.dart';
import 'package:school_cafteria/features/balance/domain/usecases/add_balance_usecase.dart';
import 'package:school_cafteria/features/balance/domain/usecases/store_weekly_balance.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'features/account/data/datasources/account_local_datasource.dart';
import 'features/account/data/datasources/account_remote_datasource.dart';
import 'features/account/data/repositories/account_repository_impl.dart';
import 'features/account/domain/repositories/account_repository.dart';
import 'features/account/domain/usecases/account_add_child.dart';
import 'features/account/domain/usecases/account_check_login.dart';
import 'features/account/domain/usecases/account_login.dart';
import 'features/account/domain/usecases/account_login_again.dart';
import 'features/account/domain/usecases/account_logout.dart';
import 'features/account/domain/usecases/account_refresh.dart';
import 'features/account/presentation/bloc/account/account_bloc.dart';
import 'features/products/data/datasources/products_remote_datasource.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/domain/repositories/products_repository.dart';
import 'features/products/domain/usecases/delete_banned_products.dart';
import 'features/products/domain/usecases/delete_day_product.dart';
import 'features/products/domain/usecases/get_all_banned_products..dart';
import 'features/products/domain/usecases/get_all_school_products..dart';
import 'features/products/domain/usecases/get_day_products.dart';
import 'features/products/domain/usecases/get_school_days.dart';
import 'features/products/domain/usecases/get_school_product_by_price.dart';
import 'features/products/domain/usecases/store_banned_products.dart';
import 'features/products/domain/usecases/store_day_products.dart';
import 'features/products/domain/usecases/store_week_products.dart';
import 'features/products/presentation/bloc/products_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Bloc

  sl.registerFactory(() => AccountBloc(
      login: sl(),
      logout: sl(),
      checkLoginUsecase: sl(),
      loginAgainUsecase: sl(),
      accountAddChildUsecase: sl(),
      accountRefreshUsecase: sl()));

  sl.registerFactory(() => ProductsBloc(
      storeBannedProductsUsecase: sl(),
      getAllSchoolProductsUsecase: sl(),
      getAllBannedProductsUsecase: sl(),
      deleteBannedProductsUsecase: sl(),
      getSchoolProductsByPriceUsecase: sl(),
      getSchoolDaysUsecase: sl(),
      getDayProductsUsecase: sl(),
      deleteDayProductUsecase: sl(),
      storeDayProductsUsecase: sl(), storeWeekProductsUsecase: sl()));

  sl.registerFactory(() => BalanceBloc(addBalanceUsecase: sl(), storeWeeklyBalanceUsecase: sl()));
// Usecases

  sl.registerLazySingleton(() => AccountAddChildUsecase(sl()));
  sl.registerLazySingleton(() => AccountLoginUsecase(sl()));
  sl.registerLazySingleton(() => AccountCheckLoginUsecase(sl()));
  sl.registerLazySingleton(() => AccountLogoutUsecase(sl()));
  sl.registerLazySingleton(() => AccountLoginAgainUsecase(sl()));
  sl.registerLazySingleton(() => AccountRefreshUsecase(sl()));
//Usecases2
  sl.registerLazySingleton(() => StoreBannedProductsUsecase(sl()));
  sl.registerLazySingleton(() => DeleteBannedProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetAllBannedProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetAllSchoolProductsUsecase(sl()));

  sl.registerLazySingleton(() => StoreDayProductsUsecase(sl()));
  sl.registerLazySingleton(() => StoreWeekProductsUsecase(sl()));
  sl.registerLazySingleton(() => DeleteDayProductUsecase(sl()));
  sl.registerLazySingleton(() => GetDayProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetSchoolDaysUsecase(sl()));
  sl.registerLazySingleton(() => GetSchoolProductsByPriceUsecase(sl()));

  //Usecases3
  sl.registerLazySingleton(() => AddBalanceUsecase(sl()));
  sl.registerLazySingleton(() => StoreWeeklyBalanceUsecase(sl()));

// Repository

  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));
// Repository 2

  sl.registerLazySingleton<ProductsRepository>(
      () => ProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Repository 3

  sl.registerLazySingleton<BalanceRepository>(
      () => BalanceRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

// Datasources

  sl.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl());

  sl.registerLazySingleton<AccountLocalDataSource>(
      () => AccountLocalDataSourceImpl(sharedPreferences: sl()));

// Datasources 2

  sl.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl());
  // Datasources 3

  sl.registerLazySingleton<BalanceRemoteDataSource>(
      () => BalanceRemoteDataSourceImpl());
//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
