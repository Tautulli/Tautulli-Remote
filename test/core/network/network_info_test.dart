import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  NetworkInfoImpl networkInfo;
  MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test(
      'should return true if Connectivity.checkConnectivity returns ConnectivityResult.wifi',
      () async {
        // arrange
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        //act
        final result = await networkInfo.isConnected;
        //assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, equals(true));
      },
    );

    test(
      'should return true if Connectivity.checkConnectivity returns ConnectivityResult.mobile',
      () async {
        // arrange
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.mobile);
        //act
        final result = await networkInfo.isConnected;
        //assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, equals(true));
      },
    );

    test(
      'should return false if Connectivity.checkConnectivity returns ConnectivityResult.none',
      () async {
        // arrange
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.none);
        //act
        final result = await networkInfo.isConnected;
        //assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, equals(false));
      },
    );
  });
}
