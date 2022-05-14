import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/network/network_info.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/src/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

import '../../../../../mock.mocks.dart';

void main() {
  late NetworkInfo networkInfo;
  late NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  late NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;

  setUp(() {
    networkInfo = MockNetworkInfo();
    numberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    numberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      networkInfo: networkInfo,
      numberTriviaLocalDataSource: numberTriviaLocalDataSource,
      numberTriviaRemoteDataSource: numberTriviaRemoteDataSource,
    );
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);
    const tNumberTrivia = tNumberTriviaModel;
    test('Should check if device is online or not', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      await numberTriviaRepositoryImpl.getConcreteNumberTrivia(1);
      //assert
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return trivia for the concrete number', () async {
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .called(1);
        expect(result, equals(const Right(tNumberTrivia)));
      });
    });
  });
  group('getRandomNumberTrivia', () {});
}
