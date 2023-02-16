import 'package:dartz/dartz.dart';
import 'package:dog_dex/core/usecases/usecase.dart';
import 'package:dog_dex/features/dog/domain/entities/dog.dart';
import 'package:dog_dex/features/dog/domain/repositories/dog_repository.dart';
import 'package:dog_dex/features/dog/domain/usecases/get_random_dog.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDogRepository extends Mock
    implements DogRepository {}

void main() {
  late GetRandomDog usecase;
  late MockDogRepository mockDogRepository;

  setUp(() {
    mockDogRepository = MockDogRepository();
    usecase = GetRandomDog(mockDogRepository);
  });

  const tDog = Dog(number: 1, text: 'test');

  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when(mockDogRepository.getRandomDog())
          .thenAnswer((_) async => const Right(tDog));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, const Right(tDog));
      verify(mockDogRepository.getRandomDog());
      verifyNoMoreInteractions(mockDogRepository);
    },
  );
}
