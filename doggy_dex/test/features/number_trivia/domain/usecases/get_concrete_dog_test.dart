import 'package:dartz/dartz.dart';
import 'package:doggydex/features/dog/domain/entities/dog.dart';
import 'package:doggydex/features/dog/domain/repositories/dog_repository.dart';
import 'package:doggydex/features/dog/domain/usecases/get_concrete_dog.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDogRepository extends Mock
    implements DogRepository {}

void main() {
  late GetConcreteDog usecase;
  late MockDogRepository mockDogRepository;

  setUp(() {
    mockDogRepository = MockDogRepository();
    usecase = GetConcreteDog(mockDogRepository);
  });

  const tNumber = 1;
  const tDog = Dog(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockDogRepository.getConcreteDog(anything as int))
          .thenAnswer((_) async => const Right(tDog));
      // act
      final result = await usecase(const Params(number: tNumber));
      // assert
      expect(result, const Right(tDog));
      verify(mockDogRepository.getConcreteDog(tNumber));
      verifyNoMoreInteractions(mockDogRepository);
    },
  );
}
