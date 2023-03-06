import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/dog.dart';
import '../../domain/repositories/dog_repository.dart';
import '../datasources/dog_local_data_source.dart';
import '../datasources/dog_remote_data_source.dart';
import '../models/dog_model.dart';

typedef _ConcreteOrRandomChooser = Future<DogModel> Function();

class DogRepositoryImpl implements DogRepository {
  final DogRemoteDataSource remoteDataSource;
  final DogLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Dog>> getConcreteDog(
    int number,
  ) async {
    return await _getDog(() {
      return remoteDataSource.getConcreteDog(number)!;
    });
  }

  @override
  Future<Either<Failure, Dog>> getRandomDog() async {
    return await _getDog(() {
      return remoteDataSource.getRandomDog();
    });
  }

  Future<Either<Failure, Dog>> _getDog(_ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDog = await getConcreteOrRandom();
        localDataSource.cacheDog(remoteDog); 
        return Right(remoteDog);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localDog = await localDataSource.getLastDog();
        return Right(localDog!);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
