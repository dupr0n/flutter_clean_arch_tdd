import 'dart:convert';
import 'dart:io';

import 'package:flutter_clean_arch_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_feature.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''Should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();
        // Act
        dataSource.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(
          mockHttpClient.get('http://numbersapi.com/$tNumber',
              headers: {'Content-Type': 'application/json'}),
        );
      },
    );
    test(
      'Should return NumberTrivia when response code is 200 (success)',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();
        // Act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // Assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'Should return a ServerException when the response code is 404 or other',
      () async {
        // Arrange
        setUpMockHttpClientFailure404();
        // Act
        final call = dataSource.getConcreteNumberTrivia;
        // Assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''Should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();
        // Act
        dataSource.getRandomNumberTrivia();
        // Assert
        verify(
          mockHttpClient.get('http://numbersapi.com/random',
              headers: {'Content-Type': 'application/json'}),
        );
      },
    );
    test(
      'Should return NumberTrivia when response code is 200 (success)',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();
        // Act
        final result = await dataSource.getRandomNumberTrivia();
        // Assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'Should return a ServerException when the response code is 404 or other',
      () async {
        // Arrange
        setUpMockHttpClientFailure404();
        // Act
        final call = dataSource.getRandomNumberTrivia;
        // Assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
