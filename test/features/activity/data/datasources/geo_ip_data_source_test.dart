import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote/features/activity/data/models/geo_ip_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetGeoipLookup extends Mock implements tautulli_api.GetGeoipLookup {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GeoIpDataSourceImpl dataSource;
  MockGetGeoipLookup mockApiGetGeoipLookup;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetGeoipLookup = MockGetGeoipLookup();
    dataSource = GeoIpDataSourceImpl(
      apiGetGeoipLookup: mockApiGetGeoipLookup,
    );
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final serverModel = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionPath: null,
    deviceToken: 'abc',
    plexName: 'Plex',
    plexIdentifier: 'xyz',
    tautulliId: 'jkl',
    primaryActive: true,
    plexPass: true,
  );

  const tIpAddress = '10.0.0.1';

  final tGeoIpItem = GeoIpItemModel(
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

  group('getGeoIp', () {
    test(
      'should call [getGeoipLookup] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetGeoipLookup(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => json.decode(fixture('geo_ip.json')));
        // act
        await dataSource.getGeoIp(
          tautulliId: serverModel.tautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetGeoipLookup(
            tautulliId: serverModel.tautulliId,
            ipAddress: tIpAddress,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return GeoIpItem',
      () async {
        // arrange
        when(
          mockApiGetGeoipLookup(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => json.decode(fixture('geo_ip.json')));
        //act
        final result = await dataSource.getGeoIp(
          tautulliId: serverModel.tautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        );
        //assert
        expect(result, equals(tGeoIpItem));
      },
    );
  });
}
