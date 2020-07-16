import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote_tdd/features/settings/presentation/bloc/register_device_bloc.dart';
import 'package:tautulli_remote_tdd/features/settings/presentation/bloc/settings_bloc.dart';

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockConnectionAddressHelper extends Mock
    implements ConnectionAddressHelper {}

void main() {
  MockRegisterDevice mockRegisterDevice;
  MockConnectionAddressHelper mockConnectionAddressHelper;
  MockSettingsBloc mockSettingsBloc;
  RegisterDeviceBloc bloc;

  setUp(() {
    mockRegisterDevice = MockRegisterDevice();
    mockSettingsBloc = MockSettingsBloc();
    mockConnectionAddressHelper = MockConnectionAddressHelper();
    bloc = RegisterDeviceBloc(
      registerDevice: mockRegisterDevice,
      connectionAddressHelper: mockConnectionAddressHelper,
    );
  });

  final String tQrCodeResult = 'http://tautulli.com|abc';
  final String tConnectionAddress = 'http://tautulli.com';
  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionUser = 'user';
  final String tConnectionPassword = 'pass';
  final String tDeviceToken = 'abc';

  final Map<String, String> tConnectionMap = {
    'protocol': tConnectionProtocol,
    'domain': tConnectionDomain,
    'user': tConnectionUser,
    'password': tConnectionPassword,
  };

  void setUpSuccess() {
    when(
      mockRegisterDevice(
        connectionProtocol: anyNamed('connectionProtocol'),
        connectionDomain: anyNamed('connectionDomain'),
        connectionUser: anyNamed('connectionUser'),
        connectionPassword: anyNamed('connectionPassword'),
        deviceToken: anyNamed('deviceToken'),
      ),
    ).thenAnswer((_) async => Right(true));
    when(mockConnectionAddressHelper.parse(tConnectionAddress))
        .thenReturn(tConnectionMap);
  }

  test(
    'initialState should be RegisterDeviceInitial',
    () async {
      // assert
      expect(bloc.state, RegisterDeviceInitial());
    },
  );

  test(
    'should call connectionAddressHelper.parse() to parse connectionAddress into connectiond details',
    () async {
      // arrange
      setUpSuccess();
      // act
      bloc.add(
        RegisterDeviceFromQrStarted(
          result: tQrCodeResult,
          settingsBloc: mockSettingsBloc,
        ),
      );
      await untilCalled(mockConnectionAddressHelper.parse(any));
      // assert
      verify(mockConnectionAddressHelper.parse(tConnectionAddress));
    },
  );

  test(
    'should call RegisterDevice usecase',
    () async {
      // arrange
      setUpSuccess();
      // act
      bloc.add(
        RegisterDeviceFromQrStarted(
          result: tQrCodeResult,
          settingsBloc: mockSettingsBloc,
        ),
      );
      await untilCalled(
        mockRegisterDevice(
          connectionProtocol: anyNamed('connectionProtocol'),
          connectionDomain: anyNamed('connectionDomain'),
          connectionUser: anyNamed('connectionUser'),
          connectionPassword: anyNamed('connectionPassword'),
          deviceToken: anyNamed('deviceToken'),
        ),
      );
      // assert
      verify(
        mockRegisterDevice(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionUser: tConnectionUser,
          connectionPassword: tConnectionPassword,
          deviceToken: tDeviceToken,
        ),
      );
    },
  );

  test(
    'should emit [RegisterDeviceInProgress, RegisterDeviceSuccess] when device is successfully registered',
    () async {
      // arrange
      setUpSuccess();
      // assert later
      final expected = [
        RegisterDeviceInitial(),
        RegisterDeviceInProgress(),
        RegisterDeviceSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(
        RegisterDeviceFromQrStarted(
          result: tQrCodeResult,
          settingsBloc: mockSettingsBloc,
        ),
      );
    },
  );

  // test(
  //   'should save connectionAddress to settings when device is successfully registered',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     // act
  //     bloc.add(RegisterDeviceFromQrStarted(result: qrCodeResult));
  //     await untilCalled(mockSetSettings.setConnectionAddress(any));
  //     // assert
  //     verify(mockSetSettings.setConnectionAddress(connectionAddress));
  //   },
  // );

  test(
    'should save connectionAddress to settings when device is successfully registered',
    () async {
      // arrange
      setUpSuccess();
      // act
      bloc.add(
        RegisterDeviceFromQrStarted(
          result: tQrCodeResult,
          settingsBloc: mockSettingsBloc,
        ),
      );
      await untilCalled(mockSettingsBloc
          .add(SettingsUpdateConnection(value: tConnectionAddress)));
      // assert
      verify(mockSettingsBloc
          .add(SettingsUpdateConnection(value: tConnectionAddress)));
    },
  );

  // test(
  //   'should save deviceToken to settings when device is successfully registered',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     // act
  //     bloc.add(RegisterDeviceFromQrStarted(result: qrCodeResult));
  //     await untilCalled(mockSetSettings.setDeviceToken(any));
  //     // assert
  //     verify(mockSetSettings.setDeviceToken(deviceToken));
  //   },
  // );

  test(
    'should save deviceToken to settings when device is successfully registered',
    () async {
      // arrange
      setUpSuccess();
      // act
      bloc.add(
        RegisterDeviceFromQrStarted(
          result: tQrCodeResult,
          settingsBloc: mockSettingsBloc,
        ),
      );
      await untilCalled(
          mockSettingsBloc.add(SettingsUpdateDeviceToken(value: tDeviceToken)));
      // assert
      verify(
          mockSettingsBloc.add(SettingsUpdateDeviceToken(value: tDeviceToken)));
    },
  );

  test(
    'should emit [RegisterDeviceInProgress, RegisterDeviceFailure] when device fails to register',
    () async {
      // arrange
      when(
        mockRegisterDevice(
          connectionProtocol: anyNamed('connectionProtocol'),
          connectionDomain: anyNamed('connectionDomain'),
          connectionUser: anyNamed('connectionUser'),
          connectionPassword: anyNamed('connectionPassword'),
          deviceToken: anyNamed('deviceToken'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure()));
      when(mockConnectionAddressHelper.parse(tConnectionAddress))
          .thenReturn(tConnectionMap);
      // assert later
      final expected = [
        RegisterDeviceInitial(),
        RegisterDeviceInProgress(),
        RegisterDeviceFailure(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(
        RegisterDeviceFromQrStarted(
          result: tQrCodeResult,
          settingsBloc: mockSettingsBloc,
        ),
      );
    },
  );
}
