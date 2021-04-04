import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/datasources/user_statistics_data_source.dart';
import 'package:tautulli_remote/features/users/data/models/user_statistic_model.dart';
import 'package:tautulli_remote/features/users/data/repositories/user_statistics_repository_impl.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_statistic.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUserStatisticsDataSource extends Mock
    implements UserStatisticsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UserStatisticsRepositoryImpl repository;
  MockUserStatisticsDataSource mockUserStatisticsDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockUserStatisticsDataSource = MockUserStatisticsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserStatisticsRepositoryImpl(
      dataSource: mockUserStatisticsDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'jkl';
  const tUserId = 123;

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
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getUserWatchTimeStats(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getUserWatchTimeStats()',
        () async {
          // act
          await repository.getUserWatchTimeStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockUserStatisticsDataSource.getUserWatchTimeStats(
              tautulliId: tTautulliId,
              userId: tUserId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of User when call to API is successful',
        () async {
          // arrange
          when(
            mockUserStatisticsDataSource.getUserWatchTimeStats(
              tautulliId: tTautulliId,
              userId: tUserId,
              settingsBloc: settingsBloc,
            ),
          ).thenAnswer((_) async => tUserWatchTimeStatsList);
          // act
          final result = await repository.getUserWatchTimeStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tUserWatchTimeStatsList)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getUserWatchTimeStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('getUserPlayerStats', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getUserPlayerStats(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getUserPlayerStats()',
        () async {
          // act
          await repository.getUserPlayerStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockUserStatisticsDataSource.getUserPlayerStats(
              tautulliId: tTautulliId,
              userId: tUserId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of User when call to API is successful',
        () async {
          // arrange
          when(
            mockUserStatisticsDataSource.getUserPlayerStats(
              tautulliId: tTautulliId,
              userId: tUserId,
              settingsBloc: settingsBloc,
            ),
          ).thenAnswer((_) async => tUserPlayerStatsList);
          // act
          final result = await repository.getUserPlayerStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tUserPlayerStatsList)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getUserPlayerStats(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
