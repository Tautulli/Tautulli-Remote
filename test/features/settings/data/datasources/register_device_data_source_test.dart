import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/core/device_info/device_info.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/data/datasources/register_device_data_source.dart';
import 'package:matcher/matcher.dart';

class MockRegisterDevice extends Mock implements tautulli_api.RegisterDevice {}

class MockDeviceInfo extends Mock implements DeviceInfo {}

class MockOneSignalDataSource extends Mock implements OneSignalDataSource {}

void main() {
  RegisterDeviceDataSourceImpl dataSource;
  MockRegisterDevice mockApiRegisterDevice;
  MockDeviceInfo mockDeviceInfo;
  MockOneSignalDataSource mockOneSignalDataSource;

  setUp(() {
    mockApiRegisterDevice = MockRegisterDevice();
    mockDeviceInfo = MockDeviceInfo();
    mockOneSignalDataSource = MockOneSignalDataSource();
    dataSource = RegisterDeviceDataSourceImpl(
      apiRegisterDevice: mockApiRegisterDevice,
      deviceInfo: mockDeviceInfo,
      oneSignal: mockOneSignalDataSource,
    );
  });

  const String tConnectionProtocol = 'http';
  const String tConnectionDomain = 'tautulli.com';
  const String tConnectionPath = '/tautulli';
  const String tDeviceToken = 'abc';
  const String tDeviceName = 'test';
  const String tDeviceId = 'lmn';
  const String tOnesignalId = 'xyz';

  void setUpMockRegisterDeviceSuccess() {
    Map<String, dynamic> registerJson = {
      "response": {
        "result": "success",
        "data": {
          "pms_name": "Starlight",
          "server_id": "<tautulli_server_id>",
          'tautulli_version': 'v0.0.0',
        }
      }
    };
    when(
      mockApiRegisterDevice(
        connectionProtocol: anyNamed('connectionProtocol'),
        connectionDomain: anyNamed('connectionDomain'),
        connectionPath: anyNamed('connectionPath'),
        deviceToken: anyNamed('deviceToken'),
        deviceId: anyNamed('deviceId'),
        deviceName: anyNamed('deviceName'),
        onesignalId: anyNamed('onesignalId'),
      ),
    ).thenAnswer((_) async => registerJson);
  }

  void setUpDeviceInfoSuccess() {
    when(mockDeviceInfo.model).thenAnswer((_) async => tDeviceName);
    when(mockDeviceInfo.uniqueId).thenAnswer((_) async => tDeviceId);
  }

  void setUpOneSignalSuccess() {
    when(mockOneSignalDataSource.userId).thenAnswer((_) async => tOnesignalId);
  }

  group('register device data source', () {
    test(
      'should query DataInfo for deviceId and uniqueId',
      () async {
        // arrange
        setUpMockRegisterDeviceSuccess();
        setUpDeviceInfoSuccess();
        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(mockDeviceInfo.model);
        verify(mockDeviceInfo.uniqueId);
      },
    );

    test(
      'should query OneSignalDataSource for userId',
      () async {
        // arrange
        setUpMockRegisterDeviceSuccess();
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(mockOneSignalDataSource.userId);
      },
    );

    test(
      'should call [registerDevice] from TautulliApi',
      () async {
        // arrange
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        setUpMockRegisterDeviceSuccess();

        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(
          mockApiRegisterDevice(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
            deviceName: tDeviceName,
            deviceId: tDeviceId,
            onesignalId: tOnesignalId,
          ),
        );
      },
    );

    test(
      'should return Map with response data',
      () async {
        // arrange
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        setUpMockRegisterDeviceSuccess();
        // act
        final result = await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        expect(result, const TypeMatcher<Map>());
      },
    );
  });
}
