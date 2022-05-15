import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';

import '../../../../../mock.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  late MockClient httpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    httpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(httpClient);
  });

  group('getConcreteNumberTrivia', () {
    final jsonData = fixture('trivia.json');
    const tNumber = 1;

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        const endpoint = 'http://numbersapi.com/$tNumber';

        when(httpClient.get(Uri.parse(endpoint))).thenAnswer(
          (_) async => http.Response(jsonData, 200),
        );

        await dataSource.getConcreteNumberTrivia(tNumber);

        verify(httpClient.get(Uri.parse(endpoint))).called(1);
      },
    );

    test(
      'should throw exception when GET is failed',
      () async {
        const endpoint = 'http://numbersapi.com/$tNumber';

        when(httpClient.get(Uri.parse(endpoint))).thenAnswer(
          (_) async => http.Response(jsonData, 400),
        );

        final result = dataSource.getConcreteNumberTrivia;

        expect(() => result(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });
  group('getRandomNumberTrivia', () {
    final jsonData = fixture('trivia.json');

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        const endpoint = 'http://numbersapi.com/random';

        when(httpClient.get(Uri.parse(endpoint))).thenAnswer(
          (_) async => http.Response(jsonData, 200),
        );

        await dataSource.getRandomNumberTrivia();

        verify(httpClient.get(Uri.parse(endpoint))).called(1);
      },
    );

    test(
      'should throw exception when GET is failed',
      () async {
        const endpoint = 'http://numbersapi.com/random';

        when(httpClient.get(Uri.parse(endpoint))).thenAnswer(
          (_) async => http.Response(jsonData, 400),
        );

        final result = dataSource.getRandomNumberTrivia;

        expect(() => result(), throwsA(isA<ServerException>()));
      },
    );
  });
}
