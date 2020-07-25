import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_tdd/core/error/failures.dart';
import 'package:flutter_clean_arch_tdd/core/usecases/usecase.dart';
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
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;
  final tNumberString = '1';
  final tNumberParsed = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  void setUpMockInputConverterSuccess() {
    when(mockInputConverter.stringToUnsignedInt(any))
        .thenReturn(Right(tNumberParsed));
  }

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be empty', () {
    // Assert
    expect(bloc.state, Empty());
  });

  //*Similarly for GetTriviaForRandomNumber
  group('GetTriviaForConcreteNumber', () {
    test(
      'Should call InputConverter to validate  and convert the string to an integer',
      () async {
        //# Arrange
        setUpMockInputConverterSuccess();
        //# Act
        bloc.add(GetNumberTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInt(any));
        //# Assert
        verify(mockInputConverter.stringToUnsignedInt(tNumberString));
      },
    );
    //! All segments below break somehow trigger 'Fail to load' the current file.
    blocTest(
      'Should emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForConcreteNumber(tNumberString)),
      expect: [Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
      verify: (bloc) => verifyZeroInteractions(mockGetConcreteNumberTrivia),
    );

    blocTest(
      'Should get data from the concrete use case',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForConcreteNumber(tNumberString)),
      verify: (_) =>
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed))),
    );

    blocTest(
      'Should expect [Loading, Loaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForConcreteNumber(tNumberString)),
      expect: [Loading(), Loaded(trivia: tNumberTrivia)],
    );
    blocTest(
      'Should expect [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForConcreteNumber(tNumberString)),
      expect: [Loading(), Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForConcreteNumber(tNumberString)),
      expect: [Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
  group('GetTriviaForRandomNumber', () {
    blocTest(
      'Should get data from the random use case',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      verify: (bloc) => verify(mockGetRandomNumberTrivia(NoParams())),
    );

    blocTest(
      'Should expect [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      expect: [Loading(), Loaded(trivia: tNumberTrivia)],
    );
    blocTest(
      'Should expect [Loading, Error] when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      expect: [Loading(), Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      expect: [Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
}
