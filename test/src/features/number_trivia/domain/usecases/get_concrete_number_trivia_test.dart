import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/usecases/usecase.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import '../../../../../mock.mocks.dart';

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository numberTriviaRepository;

  setUp(() {
    numberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(numberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia for the number from the repository', () async {
    when(numberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(const Params(number: tNumber));

    verify(numberTriviaRepository.getConcreteNumberTrivia(tNumber));
    expect(result, equals(const Right(tNumberTrivia)));
  });
}
