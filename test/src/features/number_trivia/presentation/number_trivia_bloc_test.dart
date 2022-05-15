import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/usecases/usecase.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/bloc.dart';

import '../../../../mock.mocks.dart';

void main() {
  late MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  late MockGetRandomNumberTrivia getRandomNumberTrivia;
  late MockInputConverter inputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: getConcreteNumberTrivia,
      getRandomNumberTrivia: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumberTrivia', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
        'should call the InputConverter to validate and convert string to integer',
        () async {
      when(inputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(const Right(tNumberParsed));
      when(getConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(inputConverter.stringToUnsignedInteger(tNumberString));
      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () {
        when(inputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Left(InputFailure()));

        return NumberTriviaBloc(
          getConcreteNumberTrivia: getConcreteNumberTrivia,
          getRandomNumberTrivia: getRandomNumberTrivia,
          inputConverter: inputConverter,
        );
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading,Loaded] when the getTrivia is success',
      build: () {
        when(inputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(const Right(tNumberParsed));

        when(getConcreteNumberTrivia(const Params(number: tNumberParsed)))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        return NumberTriviaBloc(
          getConcreteNumberTrivia: getConcreteNumberTrivia,
          getRandomNumberTrivia: getRandomNumberTrivia,
          inputConverter: inputConverter,
        );
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Loaded(text: tNumberTrivia.text),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading,Error] when the getTrivia is failed',
      build: () {
        when(inputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(const Right(tNumberParsed));

        when(getConcreteNumberTrivia(const Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));

        return NumberTriviaBloc(
          getConcreteNumberTrivia: getConcreteNumberTrivia,
          getRandomNumberTrivia: getRandomNumberTrivia,
          inputConverter: inputConverter,
        );
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );
  });
  group('GetTriviaForRandomNumberTrivia', () {});
}
