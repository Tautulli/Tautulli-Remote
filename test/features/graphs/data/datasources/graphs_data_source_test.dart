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

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GraphsDataSourceImpl dataSource;
  MockGetPlaysByDate mockApiGetPlaysByDate;
  MockGetPlaysByDayOfWeek mockApiGetPlaysByDayOfWeek;
  MockGetPlaysByHourOfDay mockApiGetPlaysByHourOfDay;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetPlaysByDate = MockGetPlaysByDate();
    mockApiGetPlaysByDayOfWeek = MockGetPlaysByDayOfWeek();
    mockApiGetPlaysByHourOfDay = MockGetPlaysByHourOfDay();
    dataSource = GraphsDataSourceImpl(
      apiGetPlaysByDate: mockApiGetPlaysByDate,
      apiGetPlaysByDayOfWeek: mockApiGetPlaysByDayOfWeek,
      apiGetPlaysByHourOfDay: mockApiGetPlaysByHourOfDay,
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
}