import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/activity_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSettings extends Mock implements Settings {}

class MockTautulliApiUrls extends Mock implements TautulliApiUrls {}

class MockLogging extends Mock implements Logging {}

void main() {
  ActivityDataSourceImpl dataSource;
  MockTautulliApiUrls mockTautulliApiUrls;
  MockLogging mockLogging;
  MockHttpClient mockHttpClient;
  MockSettings mockSettings;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSettings = MockSettings();
    mockTautulliApiUrls = MockTautulliApiUrls();
    mockLogging = MockLogging();
    dataSource = ActivityDataSourceImpl(
      client: mockHttpClient,
      settings: mockSettings,
      tautulliApiUrls: mockTautulliApiUrls,
      logging: mockLogging,
    );
  });

  final serverModelOne = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionUser: null,
    primaryConnectionPassword: null,
    secondaryConnectionAddress: 'https://plexpy.com',
    secondaryConnectionProtocol: 'https',
    secondaryConnectionDomain: 'plexpy.com',
    secondaryConnectionUser: null,
    secondaryConnectionPassword: null,
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
  );

  final serverModelTwo = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionUser: 'user',
    primaryConnectionPassword: 'pass',
    secondaryConnectionAddress: 'https://plexpy.com',
    secondaryConnectionProtocol: 'https',
    secondaryConnectionDomain: 'plexpy.com',
    secondaryConnectionUser: 'user',
    secondaryConnectionPassword: 'pass',
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
  );

  List<ServerModel> tServerList = [serverModelOne];

  List<ServerModel> tServerListTwo = [serverModelTwo];

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
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('activity.json'), 200));
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
      'should throw a SettingsException when the Connection Address or Device Token settings are null',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer(
          (_) async => [
            ServerModel(
              primaryConnectionAddress: null,
              primaryConnectionProtocol: null,
              primaryConnectionDomain: null,
              primaryConnectionUser: null,
              primaryConnectionPassword: null,
              deviceToken: null,
              tautulliId: null,
              plexName: null,
            ),
          ],
        );
        // act
        final call = dataSource.getActivity;
        // assert
        expect(() => call(), throwsA(TypeMatcher<SettingsException>()));
      },
    );

    group('withoutBasicAuth', () {
      test(
        'should perform a GET request on activity URL using primary connection address with application/json header',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('activity.json'), 200));
          //act
          await dataSource.getActivity();
          //assert
          verify(
            mockTautulliApiUrls.getActivityUrl(
              protocol: serverModelOne.primaryConnectionProtocol,
              domain: serverModelOne.primaryConnectionDomain,
              deviceToken: serverModelOne.deviceToken,
            ),
          );
          verify(
            mockHttpClient.get(
              any,
              headers: {
                'Content-Type': 'application/json',
              },
            ),
          );
        },
      );

      test(
        'should throw a TimeoutException if the GET request takes too long',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future.delayed(Duration(seconds: 10)));
          // act
          final call = dataSource.getActivity;
          // assert
          expect(() => call(), throwsA(TypeMatcher<TimeoutException>()));
        },
      );

      //! Does not appear to let you test actions based on caught errors
      // test(
      //   'should attempt to use secondary connection address when GET using primary throws a TimeoutException',
      //   () async {
      //     // arrange
      //     when(mockSettings.getAllServers()).thenAnswer((_) async => serverList);
      //     when(mockHttpClient.get(any, headers: anyNamed('headers')))
      //         .thenThrow(TimeoutException(''));
      //     // act
      //     await dataSource.getActivity();
      //     // assert
      //     verify(
      //       mockTautulliApiUrls.getActivityUrl(
      //         protocol: serverModelOne.secondaryConnectionProtocol,
      //         domain: serverModelOne.secondaryConnectionDomain,
      //         deviceToken: serverModelOne.deviceToken,
      //       ),
      //     );
      //     verify(
      //       mockHttpClient.get(
      //         any,
      //         headers: {
      //           'Content-Type': 'application/json',
      //         },
      //       ),
      //     );
      //   },
      // );

      test(
        'should return a Map of activity data when the response code is 200',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('activity.json'), 200));
          //act
          final result = await dataSource.getActivity();
          //assert
          expect(result, equals(tActivityMap));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response('failed', 404));
          //act
          final call = dataSource.getActivity;
          //assert
          expect(() => call(), throwsA(ServerException().runtimeType));
        },
      );
    });

    group('withBasicAuth', () {
      test(
        'should perform a GET request on activity URL using primary connection address with application/json header',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerListTwo);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('activity.json'), 200));
          //act
          await dataSource.getActivity();
          //assert
          verify(
            mockTautulliApiUrls.getActivityUrl(
              protocol: serverModelTwo.primaryConnectionProtocol,
              domain: serverModelTwo.primaryConnectionDomain,
              deviceToken: serverModelTwo.deviceToken,
            ),
          );
          verify(
            mockHttpClient.get(
              any,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Basic ' +
                    base64Encode(
                      utf8.encode(
                          '${serverModelTwo.primaryConnectionUser}:${serverModelTwo.primaryConnectionPassword}'),
                    ),
              },
            ),
          );
        },
      );

      test(
        'should throw a TimeoutException if the GET request takes too long',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future.delayed(Duration(seconds: 10)));
          // act
          final call = dataSource.getActivity;
          // assert
          expect(() => call(), throwsA(TypeMatcher<TimeoutException>()));
        },
      );

      //! Does not appear to let you test actions based on caught errors
      // test(
      //   'should attempt to use secondary connection address when GET using primary throws a TimeoutException',
      //   () async {
      //     // arrange
      //     when(mockSettings.getAllServers())
      //         .thenAnswer((_) async => tServerListTwo);
      //     when(mockHttpClient.get(any, headers: anyNamed('headers')))
      //         .thenThrow(TimeoutException(''));
      //     // act
      //     await dataSource.getActivity();
      //     // assert
      //     verify(
      //       mockTautulliApiUrls.getActivityUrl(
      //         protocol: serverModelTwo.secondaryConnectionProtocol,
      //         domain: serverModelTwo.secondaryConnectionDomain,
      //         deviceToken: serverModelTwo.deviceToken,
      //       ),
      //     );
      //     verify(
      //       mockHttpClient.get(
      //         any,
      //         headers: {
      //           'Content-Type': 'application/json',
      //           'authorization': 'Basic ' +
      //               base64Encode(
      //                 utf8.encode(
      //                     '${serverModelTwo.primaryConnectionUser}:${serverModelTwo.primaryConnectionPassword}'),
      //               ),
      //         },
      //       ),
      //     );
      //   },
      // );

      test(
        'should return a Map of activity data when the response code is 200',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('activity.json'), 200));
          //act
          final result = await dataSource.getActivity();
          //assert
          expect(result, equals(tActivityMap));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          when(mockSettings.getAllServers())
              .thenAnswer((_) async => tServerList);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response('failed', 404));
          //act
          final call = dataSource.getActivity;
          //assert
          expect(() => call(), throwsA(ServerException().runtimeType));
        },
      );
    });
  });
}
