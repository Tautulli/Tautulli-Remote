import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/models/user_statistic_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_statistic.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user_player_stats.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user_watch_time_stats.dart';
import 'package:tautulli_remote/features/users/presentation/bloc/user_statistics_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUserWatchTimeStats extends Mock implements GetUserWatchTimeStats {}

class MockGetUserPlayerStats extends Mock implements GetUserPlayerStats {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UserStatisticsBloc bloc;
  MockGetUserWatchTimeStats mockGetUserWatchTimeStats;
  MockGetUserPlayerStats mockGetUserPlayerStats;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetUserWatchTimeStats = MockGetUserWatchTimeStats();
    mockGetUserPlayerStats = MockGetUserPlayerStats();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
    bloc = UserStatisticsBloc(
      getUserPlayerStats: mockGetUserPlayerStats,
      getUserWatchTimeStats: mockGetUserWatchTimeStats,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tUserId = 123;

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

  void setUpSuccess() {
    when(mockGetUserWatchTimeStats(
      tautulliId: anyNamed('tautulliId'),
      userId: anyNamed('userId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tUserWatchTimeStatsList));
    when(mockGetUserPlayerStats(
      tautulliId: anyNamed('tautulliId'),
      userId: anyNamed('userId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tUserPlayerStatsList));
  }

  test(
    'initialState should be UserStatisticsInitial',
    () async {
      // assert
      expect(bloc.state, UserStatisticsInitial());
    },
  );

  group('UserStatisticsFetch', () {
    test(
      'should get data from GetUserWatchTimeStats use case',
      () async {
        // arrange
        clearCache();
        setUpSuccess();
        // act
        bloc.add(UserStatisticsFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(mockGetUserWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
        // assert
        verify(
          mockGetUserWatchTimeStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should get data from GetUserPlayerStats use case',
      () async {
        // arrange
        clearCache();
        setUpSuccess();
        // act
        bloc.add(UserStatisticsFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(mockGetUserPlayerStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
        // assert
        verify(
          mockGetUserPlayerStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [UserStatisticsSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          UserStatisticsInProgress(),
          UserStatisticsSuccess(
            playerStatsList: tUserPlayerStatsList,
            watchTimeStatsList: tUserWatchTimeStatsList,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UserStatisticsFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [UserStatisticsSuccess] when getWatchTimeStats is fetched successfully but getPlayerStats fails',
      () async {
        // arrange
        clearCache();
        when(mockGetUserWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Right(tUserWatchTimeStatsList));
        when(mockGetUserPlayerStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        // assert later
        final expected = [
          UserStatisticsInProgress(),
          UserStatisticsSuccess(
            playerStatsList: [],
            watchTimeStatsList: tUserWatchTimeStatsList,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UserStatisticsFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [UserStatisticsSuccess] when getPlayerStats is fetched successfully but getWatchTimeStats fails',
      () async {
        // arrange
        clearCache();
        when(mockGetUserWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        when(mockGetUserPlayerStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Right(tUserPlayerStatsList));
        // assert later
        final expected = [
          UserStatisticsInProgress(),
          UserStatisticsSuccess(
            playerStatsList: tUserPlayerStatsList,
            watchTimeStatsList: [],
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UserStatisticsFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [UserStatisticsFailure] when getWatchTimeStats and getPlayerStats fail',
      () async {
        // arrange
        clearCache();
        when(mockGetUserWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        when(mockGetUserPlayerStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        // assert later
        final expected = [
          UserStatisticsInProgress(),
          UserStatisticsFailure(
            failure: TimeoutFailure(),
            message: TIMEOUT_FAILURE_MESSAGE,
            suggestion: PLEX_CONNECTION_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UserStatisticsFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });
}
