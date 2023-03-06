import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/dog_model.dart';

abstract class DogRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<DogModel>? getConcreteDog(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<DogModel> getRandomDog();
}

class DogRemoteDataSourceImpl implements DogRemoteDataSource {
  final http.Client client;

  DogRemoteDataSourceImpl({required this.client});

  @override
  Future<DogModel>? getConcreteDog(int number) =>
      _getDogFromUrl('http://numbersapi.com/$number');

  @override
  Future<DogModel> getRandomDog() =>
      _getDogFromUrl('http://numbersapi.com/random');

  Future<DogModel> _getDogFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return DogModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
