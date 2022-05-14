// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../mock.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  late SharedPreferences sharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
        'Should return NumberTriva from shared preferences when there is one in the cache',
        () async {
      // arrange
      when(sharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(fixture('trivia.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should return NumberTriva from shared preferences when there is one in the cache',
        () async {
      // arrange
      when(sharedPreferences.getString(CACHED_NUMBER_TRIVIA)).thenReturn(null);
      // act
      final result = dataSource.getLastNumberTrivia;
      // assert
      expect(() => result(), throwsA(isA<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('Should call SharedPreferences to cache the data', () async {
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      when(
        sharedPreferences.setString(
          CACHED_NUMBER_TRIVIA,
          expectedJsonString,
        ),
      ).thenAnswer((_) async => true);
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert

      verify(
        sharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString),
      );
    });
  });
}
