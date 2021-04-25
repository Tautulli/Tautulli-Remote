import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/graphs/data/datasources/graphs_data_source.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/repositories/graphs_repository_impl.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_data.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGraphsDataSource extends Mock implements GraphsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GraphsRepositoryImpl repository;
  MockGraphsDataSource mockGraphsDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGraphsDataSource = MockGraphsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GraphsRepositoryImpl(
      dataSource: mockGraphsDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

  final playsByDateJson = json.decode(fixture('graphs_play_by_date.json'));
  final List<String> tPlaysByDateCategories = List<String>.from(
    playsByDateJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByDateSeriesDataList = [];
  playsByDateJson['response']['data']['series'].forEach((item) {
    tPlaysByDateSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByDateGraphData = GraphDataModel(
    categories: tPlaysByDateCategories,
    seriesDataList: tPlaysByDateSeriesDataList,
  );

  final playsByDayOfWeekJson =
      json.decode(fixture('graphs_play_by_dayofweek.json'));
  final List<String> tPlaysByDayOfWeekCategories = List<String>.from(
    playsByDayOfWeekJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByDayOfWeekSeriesDataList = [];
  playsByDayOfWeekJson['response']['data']['series'].forEach((item) {
    tPlaysByDayOfWeekSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByDayOfWeekGraphData = GraphDataModel(
    categories: tPlaysByDayOfWeekCategories,
    seriesDataList: tPlaysByDayOfWeekSeriesDataList,
  );

  final playsByHourOfDayJson =
      json.decode(fixture('graphs_play_by_hourofday.json'));
  final List<String> tPlaysByHourOfDayCategories = List<String>.from(
    playsByHourOfDayJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByHourOfDaySeriesDataList = [];
  playsByHourOfDayJson['response']['data']['series'].forEach((item) {
    tPlaysByHourOfDaySeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByHourOfDayGraphData = GraphDataModel(
    categories: tPlaysByHourOfDayCategories,
    seriesDataList: tPlaysByHourOfDaySeriesDataList,
  );

  final playsBySourceResolutionJson =
      json.decode(fixture('graphs_play_by_source_resolution.json'));
  final List<String> tPlaysBySourceResolutionCategories = List<String>.from(
    playsBySourceResolutionJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysBySourceResolutionSeriesDataList = [];
  playsBySourceResolutionJson['response']['data']['series'].forEach((item) {
    tPlaysBySourceResolutionSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysBySourceResolutionGraphData = GraphDataModel(
    categories: tPlaysBySourceResolutionCategories,
    seriesDataList: tPlaysBySourceResolutionSeriesDataList,
  );

  final playsByStreamResolutionJson =
      json.decode(fixture('graphs_play_by_stream_resolution.json'));
  final List<String> tPlaysByStreamResolutionCategories = List<String>.from(
    playsByStreamResolutionJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByStreamResolutionSeriesDataList = [];
  playsByStreamResolutionJson['response']['data']['series'].forEach((item) {
    tPlaysByStreamResolutionSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByStreamResolutionGraphData = GraphDataModel(
    categories: tPlaysByStreamResolutionCategories,
    seriesDataList: tPlaysByStreamResolutionSeriesDataList,
  );

  final playsByStreamTypeJson =
      json.decode(fixture('graphs_play_by_stream_type.json'));
  final List<String> tPlaysByStreamTypeCategories = List<String>.from(
    playsByStreamTypeJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByStreamTypeSeriesDataList = [];
  playsByStreamTypeJson['response']['data']['series'].forEach((item) {
    tPlaysByStreamTypeSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByStreamTypeGraphData = GraphDataModel(
    categories: tPlaysByStreamTypeCategories,
    seriesDataList: tPlaysByStreamTypeSeriesDataList,
  );

  final playsByTop10PlatformsJson =
      json.decode(fixture('graphs_play_by_top_10_platforms.json'));
  final List<String> tPlaysByTop10PlatformsCategories = List<String>.from(
    playsByTop10PlatformsJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByTop10PlatformsSeriesDataList = [];
  playsByTop10PlatformsJson['response']['data']['series'].forEach((item) {
    tPlaysByTop10PlatformsSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByTop10PlatformsGraphData = GraphDataModel(
    categories: tPlaysByTop10PlatformsCategories,
    seriesDataList: tPlaysByTop10PlatformsSeriesDataList,
  );

  final playsByTop10UsersJson =
      json.decode(fixture('graphs_play_by_top_10_users.json'));
  final List<String> tPlaysByTop10UsersCategories = List<String>.from(
    playsByTop10UsersJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByTop10UsersSeriesDataList = [];
  playsByTop10UsersJson['response']['data']['series'].forEach((item) {
    tPlaysByTop10UsersSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByTop10UsersGraphData = GraphDataModel(
    categories: tPlaysByTop10UsersCategories,
    seriesDataList: tPlaysByTop10UsersSeriesDataList,
  );

  final streamTypeByTop10PlatformsJson =
      json.decode(fixture('graphs_play_by_top_10_platforms.json'));
  final List<String> tStreamTypeByTop10PlatformsCategories = List<String>.from(
    streamTypeByTop10PlatformsJson['response']['data']['categories'],
  );
  final List<SeriesData> tStreamTypeByTop10PlatformsSeriesDataList = [];
  streamTypeByTop10PlatformsJson['response']['data']['series'].forEach((item) {
    tStreamTypeByTop10PlatformsSeriesDataList
        .add(SeriesDataModel.fromJson(item));
  });
  final tStreamTypeByTop10PlatformsGraphData = GraphDataModel(
    categories: tStreamTypeByTop10PlatformsCategories,
    seriesDataList: tStreamTypeByTop10PlatformsSeriesDataList,
  );

  group('Get Plays By Date', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByDate(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByDate()',
        () async {
          // act
          await repository.getPlaysByDate(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByDate(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByDate(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByDateGraphData);
          // act
          final result = await repository.getPlaysByDate(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByDateGraphData)));
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
          final result = await repository.getPlaysByDate(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Day of Week', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByDayOfWeek(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByDayOfWeek()',
        () async {
          // act
          await repository.getPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByDayOfWeek(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByDayOfWeek(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByDayOfWeekGraphData);
          // act
          final result = await repository.getPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByDayOfWeekGraphData)));
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
          final result = await repository.getPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Hour of Day', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByHourOfDay(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByHourOfDay()',
        () async {
          // act
          await repository.getPlaysByHourOfDay(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByHourOfDay(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByHourOfDay(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByHourOfDayGraphData);
          // act
          final result = await repository.getPlaysByHourOfDay(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByHourOfDayGraphData)));
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
          final result = await repository.getPlaysByHourOfDay(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Source Resolution', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysBySourceResolution(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysBySourceResolution()',
        () async {
          // act
          await repository.getPlaysBySourceResolution(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysBySourceResolution(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysBySourceResolution(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysBySourceResolutionGraphData);
          // act
          final result = await repository.getPlaysBySourceResolution(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysBySourceResolutionGraphData)));
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
          final result = await repository.getPlaysBySourceResolution(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Stream Resolution', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByStreamResolution(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByStreamResolution()',
        () async {
          // act
          await repository.getPlaysByStreamResolution(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByStreamResolution(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByStreamResolution(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByStreamResolutionGraphData);
          // act
          final result = await repository.getPlaysByStreamResolution(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByStreamResolutionGraphData)));
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
          final result = await repository.getPlaysByStreamResolution(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Stream Type', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByStreamType(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByStreamType()',
        () async {
          // act
          await repository.getPlaysByStreamType(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByStreamType(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByStreamType(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByStreamTypeGraphData);
          // act
          final result = await repository.getPlaysByStreamType(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByStreamTypeGraphData)));
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
          final result = await repository.getPlaysByStreamType(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Top 10 Platforms', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByTop10Platforms(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByTop10Platforms()',
        () async {
          // act
          await repository.getPlaysByTop10Platforms(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByTop10Platforms(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByTop10Platforms(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByTop10PlatformsGraphData);
          // act
          final result = await repository.getPlaysByTop10Platforms(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByTop10PlatformsGraphData)));
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
          final result = await repository.getPlaysByTop10Platforms(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Plays By Top 10 Users', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlaysByTop10Users(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlaysByTop10Users()',
        () async {
          // act
          await repository.getPlaysByTop10Users(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getPlaysByTop10Users(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getPlaysByTop10Users(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlaysByTop10UsersGraphData);
          // act
          final result = await repository.getPlaysByTop10Users(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlaysByTop10UsersGraphData)));
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
          final result = await repository.getPlaysByTop10Users(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Get Stream Type By Top 10 Platforms', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getStreamTypeByTop10Platforms(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getStreamTypeByTop10Platforms()',
        () async {
          // act
          await repository.getStreamTypeByTop10Platforms(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockGraphsDataSource.getStreamTypeByTop10Platforms(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return GraphData when call to API is successful',
        () async {
          // arrange
          when(
            mockGraphsDataSource.getStreamTypeByTop10Platforms(
              tautulliId: anyNamed('tautulliId'),
              timeRange: anyNamed('timeRange'),
              yAxis: anyNamed('yAxis'),
              userId: anyNamed('userId'),
              grouping: anyNamed('grouping'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tStreamTypeByTop10PlatformsGraphData);
          // act
          final result = await repository.getStreamTypeByTop10Platforms(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tStreamTypeByTop10PlatformsGraphData)));
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
          final result = await repository.getStreamTypeByTop10Platforms(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
