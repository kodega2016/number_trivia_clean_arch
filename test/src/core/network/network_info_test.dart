import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/network/network_info.dart';

import '../../../mock.mocks.dart';

void main() {
  late NetworkInfo networkInfo;
  late MockDataConnectionChecker dataConnectionChecker;

  setUp(() {
    dataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(dataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection', () {
      // arrange
      final expectedResult = Future.value(true);
      when(dataConnectionChecker.hasConnection)
          .thenAnswer((_) => expectedResult);

      // act
      final result = networkInfo.isConnected;

      // assert
      expect(result, expectedResult);
      verify(dataConnectionChecker.hasConnection);
      verifyNoMoreInteractions(dataConnectionChecker);
    });
  });
}
