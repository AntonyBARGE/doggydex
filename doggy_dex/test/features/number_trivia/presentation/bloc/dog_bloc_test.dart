import 'package:dartz/dartz.dart';
import 'package:doggydex/core/util/input_converter.dart';
import 'package:doggydex/features/dog/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteDog extends Mock implements GetConcreteDogEvent {}

class MockGetRandomDog extends Mock implements GetRandomDogEvent {}

class MockInputConverter extends Mock implements InputConverter {}
void main() {
  late DogBloc bloc;
  late MockGetConcreteDog mockGetConcreteDog;
  late MockGetRandomDog mockGetRandomDog;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteDog = MockGetConcreteDog(1);
    mockGetRandomDog = MockGetRandomDog();
    mockInputConverter = MockInputConverter();
    bloc = DogBloc(
        getConcreteDog: mockGetConcreteDog,
        getRandomDog: mockGetRandomDog,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () async {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tDog = Dog(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the inpus is invalid.', () async* {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      //assert later
      expectLater(bloc, emitsInOrder(expected));

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete usecase', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteDog(any))
          .thenAnswer((_) async => Right(tDog));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetRandomDog(any));

      //assert
      verify(mockGetConcreteDog(Params(number: tNumberParsed)));
    });
    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteDog(any))
          .thenAnswer((_) async => Right(tDog));

      //assert later
      final expeted = [Empty(), Loading(), Loaded(trivia: tDog)];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteDog(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expeted = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteDog(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expeted = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tDog = Dog(text: 'test trivia', number: 1);

    test('should get data from the random usecase', () async* {
      //arrange
      when(mockGetRandomDog(any))
          .thenAnswer((_) async => Right(tDog));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomDog(any));

      //assert
      verify(mockGetRandomDog(NoParams()));
    });
    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      //arrange
      when(mockGetRandomDog(any))
          .thenAnswer((_) async => Right(tDog));

      //assert later
      final expeted = [Empty(), Loading(), Loaded(trivia: tDog)];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      when(mockGetRandomDog(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expeted = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      //arrange
      when(mockGetRandomDog(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expeted = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expeted));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}