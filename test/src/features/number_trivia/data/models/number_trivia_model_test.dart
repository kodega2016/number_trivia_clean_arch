import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberModel = NumberTriviaModel(text: 'Test text', number: 1);

  test('should be a subclass of NumberTrivia entity', () {
    expect(tNumberModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () {
      final Map<String, dynamic> jsonMap = jsonDecode(
        fixture('trivia.json'),
      );

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberModel);
    });

    test(
        'should return a valid model when the JSON number is regarded as a double',
        () {
      final Map<String, dynamic> jsonMap = jsonDecode(
        fixture('trivia_double.json'),
      );
      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tNumberModel.toJson();

      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
