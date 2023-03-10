import 'dart:convert';

import 'package:doggydex/core/error/exceptions.dart';
import 'package:doggydex/features/dog/data/datasources/dog_remote_data_source.dart';
import 'package:doggydex/features/dog/data/models/dog_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late DogRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = DogRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(Uri url) {
    when(mockHttpClient.get(url, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(Uri url) {
    when(mockHttpClient.get(url, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteDog', () {
    const tNumber = 1;
    Uri uri = Uri.parse('http://numbersapi.com/$tNumber');
    final tDogModel =
        DogModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(uri);
        // act
        dataSource.getConcreteDog(tNumber);
        // assert
        verify(mockHttpClient.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Dog when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(uri);
        // act
        final result = await dataSource.getConcreteDog(tNumber);
        // assert
        expect(result, equals(tDogModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404(uri);
        // act
        final call = dataSource.getConcreteDog;
        // assert
        expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomDog', () {
    Uri randomUri = Uri.parse('http://numbersapi.com/random');
    final tDogModel =
        DogModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(randomUri);
        // act
        dataSource.getRandomDog();
        // assert
        verify(mockHttpClient.get(
          randomUri,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Dog when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(randomUri);
        // act
        final result = await dataSource.getRandomDog();
        // assert
        expect(result, equals(tDogModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404(randomUri);
        // act
        final call = dataSource.getRandomDog;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}