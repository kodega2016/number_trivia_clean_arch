import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/usecases/usecase.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../../../../mock.mocks.dart';

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository);
  });

  const tNumberTrivia = NumberTrivia(text: 'Test text', number: 1);
  test('should return trivia for random number', () async {
    when(repository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());

    verify(repository.getRandomNumberTrivia());
    expect(result, equals(const Right(tNumberTrivia)));
  });
}
