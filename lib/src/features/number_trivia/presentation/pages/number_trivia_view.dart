import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/blocs/bloc.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/widgets/trivia_actions.dart';

class NumberTriviaView extends StatefulWidget {
  const NumberTriviaView({Key? key}) : super(key: key);

  @override
  State<NumberTriviaView> createState() => _NumberTriviaViewState();
}

class _NumberTriviaViewState extends State<NumberTriviaView> {
  final _queryController = TextEditingController();
  String? _query;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: ((context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Number Trivia'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is Loaded)
                      Text(
                        state.text,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (state is Loading)
                      const Center(
                        child: LinearProgressIndicator(),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (val) => _query = val,
                      controller: _queryController,
                      enabled: state is! Loading,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter a number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TriviaActions(
                      onConcreteNumberPressed: () {
                        _queryController.clear();
                        context.read<NumberTriviaBloc>().add(
                              GetTriviaForConcreteNumber(_query ?? ''),
                            );
                      },
                      onRandomNumberPressed: () {
                        BlocProvider.of<NumberTriviaBloc>(context).add(
                          GetTriviaForRandomNumber(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
