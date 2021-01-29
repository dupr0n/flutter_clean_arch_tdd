import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_arch_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_arch_tdd/core/error/failures.dart';
import 'package:flutter_clean_arch_tdd/core/network/network_info.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImplementation repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  //! Required if you're using 'verifyZeroInteractions' for a function and previous tests 'interact' with that function
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Trivia',
      number: tNumber,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'Should check if device is online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer(
          (realInvocation) async => true,
        );
        // Act
        repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer(
          (realInvocation) async => true,
        );
      });

      test(
        'Should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
            (realInvocation) async => tNumberTriviaModel,
          );
          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'Should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
            (realInvocation) async => tNumberTriviaModel,
          );
          // Act
          await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      test(
        'Should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer(
          (realInvocation) async => false,
        );
      });
      test(
        'Should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
            (realInvocation) async => tNumberTriviaModel,
          );
          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'Should return CacheFailure when there is no cached data available',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Trivia',
      number: 123,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'Should check if device is online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer(
          (realInvocation) async => true,
        );
        // Act
        repository.getRandomNumberTrivia();
        // Assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer(
          (realInvocation) async => true,
        );
      });

      test(
        'Should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
            (realInvocation) async => tNumberTriviaModel,
          );
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'Should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
            (realInvocation) async => tNumberTriviaModel,
          );
          // Act
          await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      test(
        'Should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer(
          (realInvocation) async => false,
        );
      });
      test(
        'Should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
            (realInvocation) async => tNumberTriviaModel,
          );
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'Should return CacheFailure when there is no cached data available',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
