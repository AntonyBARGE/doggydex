import 'dart:convert';

import 'package:dog_dex/core/error/exceptions.dart';
import 'package:dog_dex/features/dog/data/datasources/dog_local_data_source.dart';
import 'package:dog_dex/features/dog/data/models/dog_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late DogLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = DogLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastDog', () {
    final tDogModel =
        DogModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return Dog from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastDog();
        // assert
        verify(mockSharedPreferences.getString(CACHED_DOG));
        expect(result, equals(tDogModel));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn("dog found");
        // act
        final call = dataSource.getLastDog;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheDog', () {
    const tDogModel = DogModel(number: 1, text: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheDog(tDogModel);
        // assert
        final expectedJsonString = json.encode(tDogModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_DOG,
          expectedJsonString,
        ));
      },
    );
  });
}
