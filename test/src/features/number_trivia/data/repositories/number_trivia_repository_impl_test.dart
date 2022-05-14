import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/core/error/failures.dart';
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

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

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

    runTestOnline(() {
      test('should return trivia for the concrete number', () async {
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .called(1);
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test('should cache gotten trivia of the concrete number', () async {
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTrivia))
            .called(1);
      });

      test(
          'Should return server failure when the call to remote data source is unsuccessfull',
          () async {
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(numberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(numberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(numberTriviaRemoteDataSource);
        verify(numberTriviaLocalDataSource.getLastNumberTrivia());
      });
      test('Should return cache failure when there is no cached data',
          () async {
        when(numberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(numberTriviaRemoteDataSource);
        verify(numberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
  group('getRandomNumberTrivia', () {});
}
