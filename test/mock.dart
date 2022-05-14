import 'package:mockito/annotations.dart';
import 'package:number_trivia/src/core/network/network_info.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';

@GenerateMocks([
  NumberTriviaRepository,
  NetworkInfo,
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
])
void main() {}
