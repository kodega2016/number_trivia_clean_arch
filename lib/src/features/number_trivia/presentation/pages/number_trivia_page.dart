import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/bloc.dart';
import 'package:number_trivia/src/injection_container.dart';

import 'number_trivia_view.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (_) => sl<NumberTriviaBloc>(),
      child: NumberTriviaView(),
    );
  }
}
