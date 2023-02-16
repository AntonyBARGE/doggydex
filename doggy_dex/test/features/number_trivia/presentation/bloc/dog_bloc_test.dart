import 'package:dartz/dartz.dart';
import 'package:doggydex/core/error/failures.dart';
import 'package:doggydex/core/usecases/usecase.dart';
import 'package:doggydex/core/util/input_converter.dart';
import 'package:doggydex/features/dog/domain/entities/dog.dart';
import 'package:doggydex/features/dog/domain/usecases/get_concrete_dog.dart';
import 'package:doggydex/features/dog/domain/usecases/get_random_dog.dart';
import 'package:doggydex/features/dog/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteDog extends Mock
    implements GetConcreteDog {}

class MockGetRandomDog extends Mock implements GetRandomDog {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late DogBloc bloc;
  late MockGetConcreteDog mockGetConcreteDog;
  late MockGetRandomDog mockGetRandomDog;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteDog = MockGetConcreteDog();
    mockGetRandomDog = MockGetRandomDog();
    mockInputConverter = MockInputConverter();

    bloc = DogBloc(
      concrete: mockGetConcreteDog,
      random: mockGetRandomDog,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tDog = Dog(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(anything as String))
            .thenReturn(const Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.add(GetConcreteDogEvent(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(anything as String));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(anything as String))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetConcreteDogEvent(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteDog(anything as Params))
            .thenAnswer((_) async => const Right(tDog));
        // act
        bloc.add(GetConcreteDogEvent(tNumberString));
        await untilCalled(mockGetConcreteDog(anything as Params));
        // assert
        verify(mockGetConcreteDog(const Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteDog(anything as Params))
            .thenAnswer((_) async => const Right(tDog));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tDog),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetConcreteDogEvent(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteDog(anything as Params))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetConcreteDogEvent(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteDog(anything as Params))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetConcreteDogEvent(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tDog = Dog(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomDog(anything as NoParams))
            .thenAnswer((_) async => const Right(tDog));
        // act
        bloc.add(GetRandomDogEvent());
        await untilCalled(mockGetRandomDog(anything as NoParams));
        // assert
        verify(mockGetRandomDog(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomDog(anything as NoParams))
            .thenAnswer((_) async => const Right(tDog));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tDog),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetRandomDogEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomDog(anything as NoParams))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetRandomDogEvent());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomDog(anything as NoParams))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetRandomDogEvent());
      },
    );
  });
}
