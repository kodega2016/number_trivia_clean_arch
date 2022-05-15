import 'package:dartz/dartz.dart';
import 'package:number_trivia/src/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        return Left(InputFailure());
      }
      return Right(integer);
    } on FormatException {
      return Left(InputFailure());
    }
  }
}
