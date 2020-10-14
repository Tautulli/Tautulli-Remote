import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli_remote/core/api/tautulli_api.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/core/error/exception.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:matcher/matcher.dart';

import '../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  TautulliApiImpl tautulliApi;
  MockHttpClient mockHttpClient;
  MockSettings mockSettings;
  MockLogging mockLogging;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    tautulliApi = TautulliApiImpl(
      client: mockHttpClient,
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';

  final tServerModel = ServerModel(
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

  group('connectionHandler', () {
    test(
      'should fetch the server from settings by tautulliId',
      () async {
        // arrange
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tServerModel);
        when(
          mockHttpClient.get(
            any,
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(fixture('activity.json'), 200));
        // act
        await tautulliApi.connectionHandler(
          tautulliId: tTautulliId,
          cmd: '',
        );
        // assert
        verify(mockSettings.getServerByTautulliId(tTautulliId));
      },
    );

    test(
      'should throw SettingsException if primaryConnectionAddress is missing',
      () async {
        // arrange
        final tBadServerModel = ServerModel(
          primaryConnectionAddress: null,
          primaryConnectionProtocol: null,
          primaryConnectionDomain: null,
          primaryConnectionPath: null,
          deviceToken: 'abc',
          plexName: null,
          tautulliId: null,
          primaryActive: true,
        );
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tBadServerModel);
        // act
        final call = tautulliApi.connectionHandler;
        // assert
        expect(
            () async => call(
                  tautulliId: tTautulliId,
                  cmd: '',
                ),
            throwsA(TypeMatcher<SettingsException>()));
      },
    );

    test(
      'should throw SettingsException if deviceToken is missing',
      () async {
        // arrange
        final tBadServerModel = ServerModel(
          primaryConnectionAddress: 'http://tautulli.com',
          primaryConnectionProtocol: null,
          primaryConnectionDomain: null,
          primaryConnectionPath: null,
          deviceToken: null,
          plexName: null,
          tautulliId: null,
          primaryActive: true,
        );
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tBadServerModel);
        // act
        final call = tautulliApi.connectionHandler;
        // assert
        expect(
          () async => call(
            tautulliId: tTautulliId,
            cmd: '',
          ),
          throwsA(TypeMatcher<SettingsException>()),
        );
      },
    );
  });

  group('fetchTautulli', () {
    test(
      'should perform a GET on address with application/json header',
      () async {
        // arrange
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tServerModel);
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('activity.json'), 200));
        // act
        await tautulliApi.fetchTautulli(
          connectionProtocol: tServerModel.primaryConnectionProtocol,
          connectionDomain: tServerModel.primaryConnectionDomain,
          connectionPath: tServerModel.primaryConnectionPath,
          deviceToken: tServerModel.deviceToken,
          cmd: '',
        );
        // assert
        verify(
          mockHttpClient.get(
            any,
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should use Uri.http if connection protocol is http',
      () async {
        // arrange
        final uri = Uri.http(
          '${tServerModel.primaryConnectionDomain}',
          '${tServerModel.primaryConnectionPath}/api/v2',
          {'cmd': '', 'apikey': tServerModel.deviceToken, 'app': 'true'},
        );
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('activity.json'), 200));
        // act
        await tautulliApi.fetchTautulli(
          connectionProtocol: tServerModel.primaryConnectionProtocol,
          connectionDomain: tServerModel.primaryConnectionDomain,
          connectionPath: tServerModel.primaryConnectionPath,
          deviceToken: tServerModel.deviceToken,
          cmd: '',
        );
        // assert
        verify(mockHttpClient.get(uri, headers: anyNamed('headers')));
      },
    );

    test(
      'should use Uri.https if connection protocol is https',
      () async {
        // arrange
        final uri = Uri.https(
          '${tServerModel.secondaryConnectionDomain}',
          '${tServerModel.secondaryConnectionPath}/api/v2',
          {'cmd': '', 'apikey': tServerModel.deviceToken, 'app': 'true'},
        );
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('activity.json'), 200));
        // act
        await tautulliApi.fetchTautulli(
          connectionProtocol: tServerModel.secondaryConnectionProtocol,
          connectionDomain: tServerModel.secondaryConnectionDomain,
          connectionPath: tServerModel.secondaryConnectionPath,
          deviceToken: tServerModel.deviceToken,
          cmd: '',
        );
        // assert
        verify(mockHttpClient.get(uri, headers: anyNamed('headers')));
      },
    );

    test(
      'should throw TimeoutException if GET request takes too long',
      () async {
        // arrange
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tServerModel);
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) => Future.delayed(Duration(seconds: 10)));
        // act
        final call = tautulliApi.fetchTautulli;
        // assert
        expect(
          () async => call(
            connectionProtocol: tServerModel.primaryConnectionProtocol,
            connectionDomain: tServerModel.primaryConnectionDomain,
            connectionPath: tServerModel.primaryConnectionPath,
            deviceToken: tServerModel.deviceToken,
            cmd: '',
          ),
          throwsA(TypeMatcher<TimeoutException>()),
        );
      },
    );

    test(
      'should throw an Exception if the JSON response is parsable but the response status code is not 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(fixture('activity.json'), 400));
        // act
        final call = tautulliApi.fetchTautulli;
        // assert
        expect(
          () async => call(
            connectionProtocol: tServerModel.primaryConnectionProtocol,
            connectionDomain: tServerModel.primaryConnectionDomain,
            connectionPath: tServerModel.primaryConnectionPath,
            deviceToken: tServerModel.deviceToken,
            cmd: '',
          ),
          throwsA(TypeMatcher<ServerException>()),
        );
      },
    );

    test(
      'should return a JSON map if GET request returns valid data',
      () async {
        // arrange
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tServerModel);
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('activity.json'), 200));
        // act
        final response = await tautulliApi.fetchTautulli(
          connectionProtocol: tServerModel.primaryConnectionProtocol,
          connectionDomain: tServerModel.primaryConnectionDomain,
          connectionPath: tServerModel.primaryConnectionPath,
          deviceToken: tServerModel.deviceToken,
          cmd: '',
        );
        // assert
        expect(response, TypeMatcher<Map>());
      },
    );

    test(
      'should throw a JsonDecodeException the response is unable to be decoded into JSON',
      () async {
        // arrange
        when(mockSettings.getServerByTautulliId(any))
            .thenAnswer((_) async => tServerModel);
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('<!doctype html>', 200));
        // act
        final call = tautulliApi.fetchTautulli;
        // assert
        expect(
          () async => call(
            connectionProtocol: tServerModel.primaryConnectionProtocol,
            connectionDomain: tServerModel.primaryConnectionDomain,
            connectionPath: tServerModel.primaryConnectionPath,
            deviceToken: tServerModel.deviceToken,
            cmd: '',
          ),
          throwsA(TypeMatcher<JsonDecodeException>()),
        );
      },
    );
  });
}
