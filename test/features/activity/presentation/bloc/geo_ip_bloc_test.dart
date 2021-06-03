import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote/features/activity/domain/usecases/get_geo_ip.dart';
import 'package:tautulli_remote/features/activity/presentation/bloc/geo_ip_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

class MockGetGeoIp extends Mock implements GetGeoIp {}

class MockLogging extends Mock implements Logging {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

void main() {
  GeoIpBloc bloc;
  MockGetGeoIp mockGetGeoIp;
  MockLogging mockLogging;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetGeoIp = MockGetGeoIp();
    mockLogging = MockLogging();
    bloc = GeoIpBloc(
      getGeoIp: mockGetGeoIp,
      logging: mockLogging,
    );
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'abc';
  const tIpAddress = '10.0.0.1';

  final tGeoIpItemModel = GeoIpItemModel(
    accuracy: null,
    city: "Toronto",
    code: "CA",
    continent: null,
    country: "Canada",
    latitude: 43.6403,
    longitude: -79.3711,
    postalCode: "M5E",
    region: "Ontario",
    timezone: "America/Toronto",
  );

  final tGeoIpMap = {
    tIpAddress: tGeoIpItemModel,
  };

  void setUpSuccess() {
    when(
      mockGetGeoIp(
        tautulliId: anyNamed('tautulliId'),
        ipAddress: anyNamed('ipAddress'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(tGeoIpItemModel));
  }

  test(
    'should get data from the GetGeoIp use case',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // act
      bloc.add(
        GeoIpLoad(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      );
      await untilCalled(
        mockGetGeoIp(
          tautulliId: anyNamed('tautulliId'),
          ipAddress: anyNamed('ipAddress'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      );
      // assert
      verify(
        mockGetGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  test(
    'should emit [GeoIpSuccess] when users list is fetched successfully',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // assert later
      final expected = [
        GeoIpInProgress(),
        GeoIpSuccess(
          geoIpMap: tGeoIpMap,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        GeoIpLoad(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  test(
    'should emit [GeoIpFailure] when fetching users list fails',
    () async {
      // arrange
      final failure = ServerFailure();
      clearCache();
      when(
        mockGetGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      ).thenAnswer((_) async => Left(failure));
      // assert later
      final expected = [
        GeoIpInProgress(),
        GeoIpFailure(
          geoIpMap: const {},
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        GeoIpLoad(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );
}
