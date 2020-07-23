import 'dart:convert';

import 'package:flutter_clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_feature.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'Should be a subclass of NumberTrivia entity',
    () async {
      // Assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'Should return a model when the JSON number is an integer',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, isA<NumberTriviaModel>());
      },
    );
    test(
      'Should return a model when the JSON number is a double',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, isA<NumberTriviaModel>());
      },
    );
  });

  group('toJson', () {
    test(
      'Should return a JSON map containing the proper',
      () async {
        // Act
        final result = tNumberTriviaModel.toJson();
        // Assert
        final expectedMap = {
          'number': 1,
          'text': 'Test Text',
        };
        expect(result, expectedMap);
      },
    );
  });
}
