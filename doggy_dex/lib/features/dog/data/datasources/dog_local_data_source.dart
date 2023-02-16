import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/dog_model.dart';

abstract class DogLocalDataSource {
  /// Gets the cached [DogModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<DogModel> getLastDog();

  Future<void> cacheDog(DogModel dogToCache);
}

const CACHED_DOG = 'CACHED_DOG';

class DogLocalDataSourceImpl implements DogLocalDataSource {
  final SharedPreferences sharedPreferences;

  DogLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<DogModel> getLastDog() {
    final jsonString = sharedPreferences.getString(CACHED_DOG);
    if (jsonString != null) {
      return Future.value(DogModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheDog(DogModel dogToCache) {
    return sharedPreferences.setString(
      CACHED_DOG,
      json.encode(dogToCache.toJson()),
    );
  }
}
