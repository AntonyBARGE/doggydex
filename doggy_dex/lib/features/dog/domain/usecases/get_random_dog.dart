import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dog.dart';
import '../repositories/dog_repository.dart';

class GetRandomDog implements UseCase<Dog, NoParams> {
  final DogRepository repository;

  GetRandomDog(this.repository);

  @override
  Future<Either<Failure, Dog>> call(NoParams params) async {
    return await repository.getRandomDog();
  }
}
