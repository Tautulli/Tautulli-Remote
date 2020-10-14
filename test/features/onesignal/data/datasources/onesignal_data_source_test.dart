import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockHttpClient mockHttpClient;
  MockNetworkInfo mockNetworkInfo;
  OneSignalDataSourceImpl dataSouce;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSouce = OneSignalDataSourceImpl(
      client: mockHttpClient,
      networkInfo: mockNetworkInfo,
    );
  });

  //TODO
  //! issues with getters acting on null
  // group('isReachable', () {
  //   group('isConnected', () {
  //     setUp(() {
  //       when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  //     });

  //     test(
  //       'should return true when onesignal.com is reachable',
  //       () async {
  //         // arrange
  //         when(mockHttpClient.get(any))
  //             .thenAnswer((_) async => http.Response('success', 200));
  //         // act
  //         final result = await dataSouce.isReachable;
  //         // assert
  //         expect(result, equals(true));
  //       },
  //     );

  //     test(
  //       'should return false when onesignal.com is unreachable',
  //       () async {
  //         // arrange
  //         when(mockHttpClient.get(any))
  //             .thenAnswer((_) async => http.Response('failure', 404));
  //         // act
  //         final result = await dataSouce.isReachable;
  //         // assert
  //         expect(result, equals(false));
  //       },
  //     );
  //   });

  //   test(
  //     'should return false when there is no network connectivity',
  //     () async {
  //       // arrange
  //       when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  //       // act
  //       final result = await dataSouce.isReachable;
  //       // assert
  //       expect(result, equals(false));
  //     },
  //   );
  // });

  // group('isSubscribed', () {});
}
