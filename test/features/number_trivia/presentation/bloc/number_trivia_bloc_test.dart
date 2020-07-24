import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_tdd/core/util/input_converter.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  final mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  final mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  final mockInputConverter = MockInputConverter();
  final bloc = NumberTriviaBloc(
    getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
    getRandomNumberTrivia: mockGetRandomNumberTrivia,
    inputConverter: mockInputConverter,
  );

  test('initialState should be empty', () {
    // Assert
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

    test(
      'Should call InputConverter to validate  and convert the string to an integer',
      () async {
        // Arrange
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Right(tNumberParsed));
        // Act
        bloc.add(GetNumberTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInt(any));
        // Assert
        verify(mockInputConverter.stringToUnsignedInt(tNumberString));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Should emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForConcreteNumber(tNumberString)),
      expect: [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );
  });
}
