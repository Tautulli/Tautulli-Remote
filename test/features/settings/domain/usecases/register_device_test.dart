import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/repositories/register_device_repository.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/register_device.dart';

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
  final String tConnectionUser = 'user';
  final String tConnectionPassword = 'pass';
  final String deviceToken = 'abc';

  group('RegisterDevice', () {
    group('without Basic Auth', () {
      test(
        'should return true when device registration is successful',
        () async {
          // arrange
          when(mockRegisterDeviceRepository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: deviceToken,
          )).thenAnswer((_) async => Right(true));
          // act
          final result = await usecase(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: deviceToken,
          );
          // assert
          expect(result, Right(true));
          verify(
            mockRegisterDeviceRepository(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: deviceToken,
            ),
          );
          verifyNoMoreInteractions(mockRegisterDeviceRepository);
        },
      );
    });

    group('with Basic Auth', () {
      test(
        'should return true when device registration is successful',
        () async {
          // arrange
          when(mockRegisterDeviceRepository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: deviceToken,
          )).thenAnswer((_) async => Right(true));
          // act
          final result = await usecase(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: deviceToken,
          );
          // assert
          expect(result, Right(true));
          verify(
            mockRegisterDeviceRepository(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: deviceToken,
            ),
          );
          verifyNoMoreInteractions(mockRegisterDeviceRepository);
        },
      );
    });
  });
}
