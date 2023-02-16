import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dog.dart';
import '../repositories/dog_repository.dart';

class GetConcreteDog implements UseCase<Dog, Params> {
  final DogRepository repository;

  GetConcreteDog(this.repository);

  @override
  Future<Either<Failure, Dog>> call(Params params) async {
    return await repository.getConcreteDog(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object> get props => [number];
}
