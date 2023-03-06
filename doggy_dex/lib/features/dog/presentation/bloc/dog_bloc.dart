import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/dog.dart';
import '../../domain/usecases/get_concrete_dog.dart';
import '../../domain/usecases/get_random_dog.dart';

part 'dog_event.dart';
part 'dog_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class DogBloc extends Bloc<DogEvent, DogState> {
  final GetConcreteDog getConcreteDog;
  final GetRandomDog getRandomDog;
  final InputConverter inputConverter;

  DogState get initialState => Empty();

  DogBloc({
    required this.getConcreteDog,
    required this.getRandomDog,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetConcreteDogEvent>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold((failure) {
        emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteDog(Params(number: integer));
        failureOrTrivia!.fold((failure) {
          emit(Error(message: _mapFailureToMessage(failure)));
        }, (dog) {
          emit(Loaded(dog: dog));
        });
      });
    });
    on<GetRandomDogEvent>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomDog(NoParams());
      failureOrTrivia!.fold((failure) {
        emit(Error(message: _mapFailureToMessage(failure)));
      }, (dog) {
        emit(Loaded(dog: dog));
      });
    });
  }
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
