import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/graphs/data/datasources/graphs_data_source.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysByDate extends Mock implements tautulli_api.GetPlaysByDate {}

class MockGetPlaysByDayOfWeek extends Mock
    implements tautulli_api.GetPlaysByDayOfWeek {}

class MockGetPlaysByHourOfDay extends Mock
    implements tautulli_api.GetPlaysByHourOfDay {}

class MockGetPlaysBySourceResolution extends Mock
    implements tautulli_api.GetPlaysBySourceResolution {}

class MockGetPlaysByStreamResolution extends Mock
    implements tautulli_api.GetPlaysByStreamResolution {}

class MockGetPlaysByStreamType extends Mock
    implements tautulli_api.GetPlaysByStreamType {}

class MockGetPlaysByTop10Platforms extends Mock
    implements tautulli_api.GetPlaysByTop10Platforms {}

class MockGetPlaysByTop10Users extends Mock
    implements tautulli_api.GetPlaysByTop10Users {}

class MockGetStreamTypeByTop10Platforms extends Mock
    implements tautulli_api.GetStreamTypeByTop10Platforms {}

class MockGetStreamTypeByTop10Users extends Mock
    implements tautulli_api.GetStreamTypeByTop10Users {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GraphsDataSourceImpl dataSource;
  MockGetPlaysByDate mockApiGetPlaysByDate;
  MockGetPlaysByDayOfWeek mockApiGetPlaysByDayOfWeek;
  MockGetPlaysByHourOfDay mockApiGetPlaysByHourOfDay;
  MockGetPlaysBySourceResolution mockApiGetPlaysBySourceResolution;
  MockGetPlaysByStreamResolution mockApiGetPlaysByStreamResolution;
  MockGetPlaysByStreamType mockApiGetPlaysByStreamType;
  MockGetPlaysByTop10Platforms mockApiGetPlaysByTop10Platforms;
  MockGetPlaysByTop10Users mockApiGetPlaysByTop10Users;
  MockGetStreamTypeByTop10Platforms mockApiGetStreamTypeByTop10Platforms;
  MockGetStreamTypeByTop10Users mockApiGetStreamTypeByTop10Users;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetPlaysByDate = MockGetPlaysByDate();
    mockApiGetPlaysByDayOfWeek = MockGetPlaysByDayOfWeek();
    mockApiGetPlaysByHourOfDay = MockGetPlaysByHourOfDay();
    mockApiGetPlaysBySourceResolution = MockGetPlaysBySourceResolution();
    mockApiGetPlaysByStreamResolution = MockGetPlaysByStreamResolution();
    mockApiGetPlaysByStreamType = MockGetPlaysByStreamType();
    mockApiGetPlaysByTop10Platforms = MockGetPlaysByTop10Platforms();
    mockApiGetPlaysByTop10Users = MockGetPlaysByTop10Users();
    mockApiGetStreamTypeByTop10Platforms = MockGetStreamTypeByTop10Platforms();
    mockApiGetStreamTypeByTop10Users = MockGetStreamTypeByTop10Users();
    dataSource = GraphsDataSourceImpl(
      apiGetPlaysByDate: mockApiGetPlaysByDate,
      apiGetPlaysByDayOfWeek: mockApiGetPlaysByDayOfWeek,
      apiGetPlaysByHourOfDay: mockApiGetPlaysByHourOfDay,
      apiGetPlaysBySourceResolution: mockApiGetPlaysBySourceResolution,
      apiGetPlaysByStreamResolution: mockApiGetPlaysByStreamResolution,
      apiGetPlaysByStreamType: mockApiGetPlaysByStreamType,
      apiGetPlaysByTop10Platforms: mockApiGetPlaysByTop10Platforms,
      apiGetPlaysByTop10Users: mockApiGetPlaysByTop10Users,
      apiGetStreamTypeByTop10Platforms: mockApiGetStreamTypeByTop10Platforms,
      apiGetStreamTypeByTop10Users: mockApiGetStreamTypeByTop10Users,
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
      json.decode(fixture('graphs_stream_type_by_top_10_platforms.json'));
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

  final streamTypeByTop10UsersJson =
      json.decode(fixture('graphs_stream_type_by_top_10_users.json'));
  final List<String> tStreamTypeByTop10UsersCategories = List<String>.from(
    streamTypeByTop10UsersJson['response']['data']['categories'],
  );
  final List<SeriesData> tStreamTypeByTop10UsersSeriesDataList = [];
  streamTypeByTop10UsersJson['response']['data']['series'].forEach((item) {
    tStreamTypeByTop10UsersSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tStreamTypeByTop10UsersGraphData = GraphDataModel(
    categories: tStreamTypeByTop10UsersCategories,
    seriesDataList: tStreamTypeByTop10UsersSeriesDataList,
  );

  group('getPlayByDate', () {
    test(
      'should call [getPlaysByDate] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByDate(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByDateJson);
        // act
        await dataSource.getPlaysByDate(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByDate(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByDate(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByDateJson);
      // act
      final result = await dataSource.getPlaysByDate(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByDateGraphData));
    },
  );

  group('getPlayByDayOfWeek', () {
    test(
      'should call [getPlaysByDayOfWeek] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByDayOfWeek(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByDayOfWeekJson);
        // act
        await dataSource.getPlaysByDayOfWeek(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByDayOfWeek(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByDayOfWeek(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByDayOfWeekJson);
      // act
      final result = await dataSource.getPlaysByDayOfWeek(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByDayOfWeekGraphData));
    },
  );

  group('getPlayByHourOfDay', () {
    test(
      'should call [getPlaysByHourOfDay] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByHourOfDay(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByHourOfDayJson);
        // act
        await dataSource.getPlaysByHourOfDay(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByHourOfDay(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByHourOfDay(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByHourOfDayJson);
      // act
      final result = await dataSource.getPlaysByHourOfDay(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByHourOfDayGraphData));
    },
  );

  group('getPlayByStreamResolution', () {
    test(
      'should call [getPlaysByStreamResolution] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByStreamResolution(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByStreamResolutionJson);
        // act
        await dataSource.getPlaysByStreamResolution(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByStreamResolution(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByStreamResolution(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByStreamResolutionJson);
      // act
      final result = await dataSource.getPlaysByStreamResolution(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByStreamResolutionGraphData));
    },
  );

  group('getPlayBySourceResolution', () {
    test(
      'should call [getPlaysBySourceResolution] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysBySourceResolution(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsBySourceResolutionJson);
        // act
        await dataSource.getPlaysBySourceResolution(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysBySourceResolution(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysBySourceResolution(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsBySourceResolutionJson);
      // act
      final result = await dataSource.getPlaysBySourceResolution(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysBySourceResolutionGraphData));
    },
  );

  group('getPlayByStreamType', () {
    test(
      'should call [getPlaysByStreamType] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByStreamType(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByStreamTypeJson);
        // act
        await dataSource.getPlaysByStreamType(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByStreamType(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByStreamType(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByStreamTypeJson);
      // act
      final result = await dataSource.getPlaysByStreamType(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByStreamTypeGraphData));
    },
  );

  group('getPlayByTop10Platforms', () {
    test(
      'should call [getPlayByTop10Platforms] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByTop10Platforms(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByTop10PlatformsJson);
        // act
        await dataSource.getPlaysByTop10Platforms(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByTop10Platforms(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByTop10Platforms(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByTop10PlatformsJson);
      // act
      final result = await dataSource.getPlaysByTop10Platforms(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByTop10PlatformsGraphData));
    },
  );

  group('getPlayByTop10Users', () {
    test(
      'should call [getPlayByTop10Users] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetPlaysByTop10Users(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => playsByTop10UsersJson);
        // act
        await dataSource.getPlaysByTop10Users(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetPlaysByTop10Users(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetPlaysByTop10Users(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => playsByTop10UsersJson);
      // act
      final result = await dataSource.getPlaysByTop10Users(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tPlaysByTop10UsersGraphData));
    },
  );

  group('getStreamTypeByTop10Platforms', () {
    test(
      'should call [getStreamTypeByTop10Platforms] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetStreamTypeByTop10Platforms(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => streamTypeByTop10PlatformsJson);
        // act
        await dataSource.getStreamTypeByTop10Platforms(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetStreamTypeByTop10Platforms(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetStreamTypeByTop10Platforms(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => streamTypeByTop10PlatformsJson);
      // act
      final result = await dataSource.getStreamTypeByTop10Platforms(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tStreamTypeByTop10PlatformsGraphData));
    },
  );

  group('getStreamTypeByTop10Users', () {
    test(
      'should call [getStreamTypeByTop10Users] from Tautulli API',
      () async {
        // arrange
        when(mockApiGetStreamTypeByTop10Users(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => streamTypeByTop10UsersJson);
        // act
        await dataSource.getStreamTypeByTop10Users(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetStreamTypeByTop10Users(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  test(
    'should return a GraphsDataModel',
    () async {
      // arrange
      when(mockApiGetStreamTypeByTop10Users(
        tautulliId: anyNamed('tautulliId'),
        timeRange: anyNamed('timeRange'),
        yAxis: anyNamed('yAxis'),
        userId: anyNamed('userId'),
        grouping: anyNamed('grouping'),
        settingsBloc: anyNamed('settingsBloc'),
      )).thenAnswer((_) async => streamTypeByTop10UsersJson);
      // act
      final result = await dataSource.getStreamTypeByTop10Users(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(tStreamTypeByTop10UsersGraphData));
    },
  );
}
