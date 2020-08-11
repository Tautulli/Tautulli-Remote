import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/activity_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettings extends Mock implements Settings {}

class MockTautulliApi extends Mock implements TautulliApi {}

class MockLogging extends Mock implements Logging {}

void main() {
  ActivityDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;
  MockLogging mockLogging;
  MockSettings mockSettings;

  setUp(() {
    mockSettings = MockSettings();
    mockTautulliApi = MockTautulliApi();
    mockLogging = MockLogging();
    dataSource = ActivityDataSourceImpl(
      settings: mockSettings,
      tautulliApi: mockTautulliApi,
      logging: mockLogging,
    );
  });

  final serverModelOne = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionPath: null,
    secondaryConnectionAddress: 'https://plexpy.com',
    secondaryConnectionProtocol: 'https',
    secondaryConnectionDomain: 'plexpy.com',
    secondaryConnectionPath: null,
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
    primaryActive: true,
  );

  final serverModelTwo = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionPath: '/tautulli',
    secondaryConnectionAddress: 'https://plexpy.com',
    secondaryConnectionProtocol: 'https',
    secondaryConnectionDomain: 'plexpy.com',
    secondaryConnectionPath: '/plexpy',
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
    primaryActive: true,
  );

  List<ServerModel> tServerList = [serverModelOne];

  List<ActivityItem> tActivityList = [];

  final tActivityJson = json.decode(fixture('activity.json'));

  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        ActivityItemModel.fromJson(session),
      );
    },
  );

  Map<String, Map<String, Object>> tActivityMap = {
    'jkl': {
      'plex_name': 'Plex',
      'result': 'success',
      'activity': tActivityList,
    }
  };

  group('getActivity', () {
    test(
      'should get a list of servers from Settings',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        when(mockTautulliApi.getActivity(any))
            .thenAnswer((_) async => json.decode(fixture('activity.json')));
        // act
        await dataSource.getActivity();
        // assert
        verify(mockSettings.getAllServers());
      },
    );

    test(
      'should throw MissingServerException if getAllServers() returns nothing',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => []);
        // act
        final call = dataSource.getActivity;
        // assert
        expect(() => call(), throwsA(TypeMatcher<MissingServerException>()));
      },
    );

    test(
      'should throw a SettingsException when the tautulliId or plexName settings are null',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer(
          (_) async => [
            ServerModel(
              primaryConnectionAddress: serverModelOne.primaryConnectionAddress,
              primaryConnectionProtocol:
                  serverModelOne.primaryConnectionProtocol,
              primaryConnectionDomain: serverModelOne.primaryConnectionDomain,
              primaryConnectionPath: serverModelOne.primaryConnectionPath,
              deviceToken: serverModelOne.deviceToken,
              tautulliId: null,
              plexName: null,
              primaryActive: true,
            ),
          ],
        );
        // act
        final call = dataSource.getActivity;
        // assert
        expect(() => call(), throwsA(TypeMatcher<SettingsException>()));
      },
    );

    test(
      'should throw a SettingsException when the Connection Address or Device Token settings are null',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer(
          (_) async => [
            ServerModel(
              primaryConnectionAddress: null,
              primaryConnectionProtocol: null,
              primaryConnectionDomain: null,
              primaryConnectionPath: null,
              deviceToken: null,
              tautulliId: serverModelOne.tautulliId,
              plexName: serverModelOne.plexName,
              primaryActive: true,
            ),
          ],
        );
        // act
        final call = dataSource.getActivity;
        // assert
        expect(() => call(), throwsA(TypeMatcher<SettingsException>()));
      },
    );

    test(
      'should call [getActivity] from TautulliApi',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        when(mockTautulliApi.getActivity(any))
            .thenAnswer((_) async => json.decode(fixture('activity.json')));
        //act
        await dataSource.getActivity();
        //assert
        verify(mockTautulliApi.getActivity(tServerList[0].tautulliId));
      },
    );

    test(
      'should return a Map of activity data',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        when(mockTautulliApi.getActivity(any))
            .thenAnswer((_) async => json.decode(fixture('activity.json')));
        //act
        final result = await dataSource.getActivity();
        //assert
        expect(result, equals(tActivityMap));
      },
    );
  });
}
