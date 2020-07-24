import 'package:flutter_clean_arch_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'Should forward the call to DaatConnectionChecker().hasConnection',
      () async {
        // Arrange
        final tHasConnectionFuture = Future.value(true);
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((realInvocation) => tHasConnectionFuture);
        // Act
        final result = networkInfoImpl.isConnected;
        // Assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
