// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final cachedData = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (cachedData != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(cachedData)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    await sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson()),
    );
  }
}
