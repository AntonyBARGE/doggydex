import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/dog.dart';

abstract class DogRepository {
  Future<Either<Failure, Dog>>? getConcreteDog(int number);
  Future<Either<Failure, Dog>>? getRandomDog();
}
