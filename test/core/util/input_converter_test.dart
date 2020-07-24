import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_tdd/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter = InputConverter();

  group('stringToUnsignedInt', () {
    test(
      'Should return an integer when the string represents an unsigned integer',
      () async {
        // Arrange
        final str = '123';
        // Act
        final result = inputConverter.stringToUnsignedInt(str);
        // Assert
        expect(result, Right(123));
      },
    );

    test(
      'Should return a Failure when the string is not an integer',
      () async {
        // Arrange
        final str = 'ab3';
        // Act
        final result = inputConverter.stringToUnsignedInt(str);
        // Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
    test(
      'Should return a Failure when the string is a negative integer',
      () async {
        // Arrange
        final str = '-123';
        // Act
        final result = inputConverter.stringToUnsignedInt(str);
        // Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
