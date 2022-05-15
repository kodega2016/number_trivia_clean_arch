import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final String text;

  Loaded({required this.text});

  @override
  List<Object> get props => [text];
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
