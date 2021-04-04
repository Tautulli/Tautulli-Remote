import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/datasources/user_statistics_data_source.dart';
import 'package:tautulli_remote/features/users/data/models/user_statistic_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_statistic.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUserWatchTimeStats extends Mock
    implements tautulliApi.GetUserWatchTimeStats {}

class MockGetUserPlayerStats extends Mock
    implements tautulliApi.GetUserPlayerStats {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UserStatisticsDataSourceImpl dataSource;
  MockGetUserWatchTimeStats mockApiGetUserWatchTimeStats;
  MockGetUserPlayerStats mockApiGetUserPlayerStats;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetUserWatchTimeStats = MockGetUserWatchTimeStats();
    mockApiGetUserPlayerStats = MockGetUserPlayerStats();
    dataSource = UserStatisticsDataSourceImpl(
      apiGetUserWatchTimeStats: mockApiGetUserWatchTimeStats,
      apiGetUserPlayerStats: mockApiGetUserPlayerStats,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const int tUserId = 123;

  final List<UserStatistic> tUserWatchTimeStatsList = [];
  final List<UserStatistic> tUserPlayerStatsList = [];

  final userWatchTimeStatsJson =
      json.decode(fixture('user_watch_time_stats.json'));
  final userPlayerStatsJson = json.decode(fixture('user_player_stats.json'));

  userWatchTimeStatsJson['response']['data'].forEach((item) {
    tUserWatchTimeStatsList.add(UserStatisticModel.fromJson(
      userStatisticType: UserStatisticType.watchTime,
      json: item,
    ));
  });
  userPlayerStatsJson['response']['data'].forEach((item) {
    tUserPlayerStatsList.add(UserStatisticModel.fromJson(
      userStatisticType: UserStatisticType.player,
      json: item,
    ));
  });

  group('getUserWatchTimeStats', () {
    test(
      'should call [getUserWatchTimeStats] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetUserWatchTimeStats(
            tautulliId: anyNamed('tautulliId'),
            userId: anyNamed('userId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => userWatchTimeStatsJson);
        // act
        await dataSource.getUserWatchTimeStats(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetUserWatchTimeStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of UserStatistic',
      () async {
        // arrange
        when(
          mockApiGetUserWatchTimeStats(
            tautulliId: anyNamed('tautulliId'),
            userId: anyNamed('userId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => userWatchTimeStatsJson);
        // act
        final result = await dataSource.getUserWatchTimeStats(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tUserWatchTimeStatsList));
      },
    );
  });

  group('getUserPlayerStats', () {
    test(
      'should call [getUserPlayerStats] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetUserPlayerStats(
            tautulliId: anyNamed('tautulliId'),
            userId: anyNamed('userId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => userPlayerStatsJson);
        // act
        await dataSource.getUserPlayerStats(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetUserPlayerStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of UserStatistic',
      () async {
        // arrange
        when(
          mockApiGetUserPlayerStats(
            tautulliId: anyNamed('tautulliId'),
            userId: anyNamed('userId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => userPlayerStatsJson);
        // act
        final result = await dataSource.getUserPlayerStats(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tUserPlayerStatsList));
      },
    );
  });
}
