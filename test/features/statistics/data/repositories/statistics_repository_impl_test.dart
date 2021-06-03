import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/statistics/data/datasources/statistics_data_source.dart';
import 'package:tautulli_remote/features/statistics/data/models/statistics_model.dart';
import 'package:tautulli_remote/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:tautulli_remote/features/statistics/domain/entities/statistics.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockStatisticsDataSource extends Mock implements StatisticsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  StatisticsRepositoryImpl repository;
  MockStatisticsDataSource mockStatisticsDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockStatisticsDataSource = MockStatisticsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = StatisticsRepositoryImpl(
      dataSource: mockStatisticsDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
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

  const String tTautulliId = 'jkl';

  final statisticsJson = json.decode(fixture('statistics.json'));
  Map<String, List<Statistics>> tStatisticsMap = {
    'top_tv': [],
    'popular_tv': [],
    'top_movies': [],
    'popular_movies': [],
    'top_music': [],
    'popular_music': [],
    'last_watched': [],
    'top_platforms': [],
    'top_users': [],
    'most_concurrent': [],
    'top_libraries': [],
  };

  statisticsJson['response']['data'].forEach((statistic) {
    statistic['rows'].forEach((item) {
      tStatisticsMap[statistic['stat_id']].add(
        StatisticsModel.fromJson(
          statId: statistic['stat_id'],
          json: item,
        ),
      );
    });
  });

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getStatistics(
        tautulliId: tTautulliId,
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
      'should call the data source getStatistics()',
      () async {
        // act
        await repository.getStatistics(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockStatisticsDataSource.getStatistics(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return map of statistics with lists of StatisticsModel when call to API is successful',
      () async {
        // arrange
        when(
          mockStatisticsDataSource.getStatistics(
            tautulliId: anyNamed('tautulliId'),
            grouping: anyNamed('grouping'),
            statsCount: anyNamed('statsCount'),
            statsType: anyNamed('statsType'),
            timeRange: anyNamed('timeRange'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tStatisticsMap);
        // act
        final result = await repository.getStatistics(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Right(tStatisticsMap)));
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
        final result = await repository.getStatistics(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
