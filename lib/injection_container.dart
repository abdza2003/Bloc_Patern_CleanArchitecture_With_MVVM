import 'package:school_cafteria/features/account/data/datasources/account_local_datasource.dart';
import 'package:school_cafteria/features/account/data/datasources/account_remote_datasource.dart';
import 'package:school_cafteria/features/account/data/repositories/account_repository_impl.dart';
import 'package:school_cafteria/features/account/domain/repositories/account_repository.dart';
import 'package:school_cafteria/features/account/domain/usecases/account_check_login.dart';

import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/account/domain/usecases/account_add_child.dart';
import 'features/account/domain/usecases/account_login.dart';
import 'features/account/domain/usecases/account_login_again.dart';
import 'features/account/domain/usecases/account_logout.dart';
import 'features/account/presentation/bloc/account/account_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Bloc

  sl.registerFactory(() => AccountBloc(login: sl(),logout:sl(), checkLoginUsecase: sl(), loginAgainUsecase: sl()));


// Usecases

  sl.registerLazySingleton(() => AccountAddChildUsecase(sl()));
  sl.registerLazySingleton(() => AccountLoginUsecase(sl()));
  sl.registerLazySingleton(() => AccountCheckLoginUsecase(sl()));
  sl.registerLazySingleton(() => AccountLogoutUsecase(sl()));
  sl.registerLazySingleton(() => AccountLoginAgainUsecase(sl()));

// Repository

  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(),localDataSource: sl()));

// Datasources

  sl.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl());
   sl.registerLazySingleton<AccountLocalDataSource>(
       () => AccountLocalDataSourceImpl(sharedPreferences: sl()));

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External


  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
