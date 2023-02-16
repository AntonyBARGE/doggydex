import 'package:dartz/dartz.dart';
import 'package:doggydex/core/error/exceptions.dart';
import 'package:doggydex/core/error/failures.dart';
import 'package:doggydex/core/network/network_info.dart';
import 'package:doggydex/features/dog/data/datasources/dog_local_data_source.dart';
import 'package:doggydex/features/dog/data/datasources/dog_remote_data_source.dart';
import 'package:doggydex/features/dog/data/repositories/dog_repository_impl.dart';
import 'package:doggydex/features/dog/data/models/dog_model.dart';
import 'package:doggydex/features/dog/domain/entities/dog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements DogRemoteDataSource {}

class MockLocalDataSource extends Mock implements DogLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late DogRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DogRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteDog', () {
    const tNumber = 1;
    const tDogModel = DogModel(number: tNumber, text: 'test trivia');
    const Dog tDog = tDogModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteDog(tNumber);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteDog(any()))
              .thenAnswer((_) async => tDogModel);
          // act
          final result = await repository.getConcreteDog(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteDog(tNumber));
          expect(result, equals(const Right(tDog)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteDog(any()))
              .thenAnswer((_) async => tDogModel);
          // act
          await repository.getConcreteDog(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteDog(tNumber));
          verify(() => mockLocalDataSource.cacheDog(tDogModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteDog(any()))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteDog(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteDog(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastDog())
              .thenAnswer((_) async => tDogModel);
          // act
          final result = await repository.getConcreteDog(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastDog());
          expect(result, equals(const Right(tDog)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastDog())
              .thenThrow(CacheException());
          // act
          final result = await repository.getConcreteDog(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastDog());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomDog', () {
    const tDogModel = DogModel(number: 123, text: 'test trivia');
    const Dog tDog = tDogModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomDog();
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomDog())
              .thenAnswer((_) async => tDogModel);
          // act
          final result = await repository.getRandomDog();
          // assert
          verify(() => mockRemoteDataSource.getRandomDog());
          expect(result, equals(const Right(tDog)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomDog())
              .thenAnswer((_) async => tDogModel);
          // act
          await repository.getRandomDog();
          // assert
          verify(() => mockRemoteDataSource.getRandomDog());
          verify(() => mockLocalDataSource.cacheDog(tDogModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomDog())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomDog();
          // assert
          verify(() => mockRemoteDataSource.getRandomDog());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastDog())
              .thenAnswer((_) async => tDogModel);
          // act
          final result = await repository.getRandomDog();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastDog());
          expect(result, equals(const Right(tDog)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastDog())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomDog();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastDog());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
