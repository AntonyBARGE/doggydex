import 'dart:convert';

import 'package:doggydex/features/dog/data/models/dog_model.dart';
import 'package:doggydex/features/dog/domain/entities/dog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tDogModel = DogModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of Dog entity',
    () async {
      // assert
      expect(tDogModel, isA<Dog>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = DogModel.fromJson(jsonMap);
        // assert
        expect(result, tDogModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = DogModel.fromJson(jsonMap);
        // assert
        expect(result, tDogModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tDogModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
