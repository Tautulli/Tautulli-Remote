import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/settings/domain/repositories/register_device_repository.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

class MockRegisterDeviceRepository extends Mock
    implements RegisterDeviceRepository {}

void main() {
  RegisterDevice usecase;
  MockRegisterDeviceRepository mockRegisterDeviceRepository;

  setUp(() {
    mockRegisterDeviceRepository = MockRegisterDeviceRepository();
    usecase = RegisterDevice(
      repository: mockRegisterDeviceRepository,
    );
  });

  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionPath = '/tautulli';
  final String deviceToken = 'abc';

  group('RegisterDevice', () {
    test(
      'should return a Map with response data when device registration is successful',
      () async {
        // arrange
        Map responseMap = {
          "data": {"pms_name": "Starlight", "server_id": "abc"}
        };
        when(mockRegisterDeviceRepository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: deviceToken,
        )).thenAnswer((_) async => Right(responseMap));
        // act
        final result = await usecase(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: deviceToken,
        );
        // assert
        expect(result, Right(responseMap));
        verify(
          mockRegisterDeviceRepository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: deviceToken,
          ),
        );
        verifyNoMoreInteractions(mockRegisterDeviceRepository);
      },
    );
  });
}
