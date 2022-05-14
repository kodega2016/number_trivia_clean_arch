import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:number_trivia/src/core/network/network_info.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  NumberTriviaRepository,
  NetworkInfo,
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  DataConnectionChecker,
  SharedPreferences,
  http.Client,
])
void main() {}
