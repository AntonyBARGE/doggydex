import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/dog.dart';
import '../../domain/usecases/get_concrete_dog.dart';
import '../../domain/usecases/get_random_dog.dart';
import 'bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class DogBloc extends Bloc<DogEvent, DogState> {
  final GetConcreteDog getConcreteDog;
  final GetRandomDog getRandomDog;
  final InputConverter inputConverter;

  @override
  DogState get initialState => Empty();

  DogBloc({
    required GetConcreteDog concrete,
    required GetRandomDog random,
    required this.inputConverter,
  })  : getConcreteDog = concrete,
        getRandomDog = random, super(Empty());


  @override
  Stream<DogState> mapEventToState(
    DogEvent event,
  ) async* {
    if (event is GetConcreteDogEvent) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrDog =
              await getConcreteDog(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrDog);
        },
      );
    } else if (event is GetRandomDogEvent) {
      yield Loading();
      final failureOrDog = await getRandomDog(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrDog);
    }
  }

  Stream<DogState> _eitherLoadedOrErrorState(
    Either<Failure, Dog> failureOrDog,
  ) async* {
    yield failureOrDog.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}