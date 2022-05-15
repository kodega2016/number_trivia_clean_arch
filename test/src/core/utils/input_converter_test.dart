import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      const str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(123));
    });

    test('should return input failurea when the string is not an integer', () {
      const str = 'he';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InputFailure()));
    });

    test(
      'should return a failure when the string is a negative integer',
      () async {
        const str = '-123';
        final result = inputConverter.stringToUnsignedInteger(str);
        expect(result, Left(InputFailure()));
      },
    );
  });
}
