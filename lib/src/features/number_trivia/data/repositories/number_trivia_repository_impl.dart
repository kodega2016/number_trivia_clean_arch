import 'package:dartz/dartz.dart';
import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/network/network_info.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NetworkInfo networkInfo;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;

  NumberTriviaRepositoryImpl({
    required this.networkInfo,
    required this.numberTriviaLocalDataSource,
    required this.numberTriviaRemoteDataSource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
      () => numberTriviaRemoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(
      () => numberTriviaRemoteDataSource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandomNumberTrivia,
  ) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandomNumberTrivia();
        await numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
