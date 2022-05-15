// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/src/core/usecases/usecase.dart';
import 'package:number_trivia/src/core/utils/input_converter.dart';
import 'package:number_trivia/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/number_trivia_event.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (l) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (number) async {
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: number));

        failureOrTrivia.fold(
          (failure) => emit(Error(message: SERVER_FAILURE_MESSAGE)),
          (trivia) => emit(Loaded(text: trivia.text)),
        );
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {}
}
