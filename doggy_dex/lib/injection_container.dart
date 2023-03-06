import 'core/network/network_info.dart';
import 'features/dog/data/datasources/dog_local_data_source.dart';
import 'features/dog/data/datasources/dog_remote_data_source.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/input_converter.dart';
import 'features/dog/data/repositories/dog_repository_impl.dart';
import 'features/dog/domain/repositories/dog_repository.dart';
import 'features/dog/domain/usecases/get_concrete_dog.dart';
import 'features/dog/presentation/bloc/dog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'features/dog/domain/usecases/get_random_dog.dart';

// service locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Dog
  sl.registerFactory(() => DogBloc(
      getConcreteDog: sl(),
      getRandomDog: sl(),
      inputConverter: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetConcreteDog(sl()));
  sl.registerLazySingleton(() => GetRandomDog(sl()));

  // Repository
  sl.registerLazySingleton<DogRepository>(
      () => DogRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
  // Data sources
  sl.registerLazySingleton<DogRemoteDataSource>(
      () => DogRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<DogLocalDataSource>(
      () => DogLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
