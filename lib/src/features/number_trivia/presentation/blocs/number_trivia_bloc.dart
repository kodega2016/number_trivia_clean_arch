import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/number_trivia_event.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc(super.initialState);
}
