import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/graphs/data/datasources/graphs_data_source.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_data.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysByDate extends Mock implements tautulli_api.GetPlaysByDate {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GraphsDataSourceImpl dataSource;
  MockGetPlaysByDate mockApiGetPlaysByDate;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetPlaysByDate = MockGetPlaysByDate();
    dataSource = GraphsDataSourceImpl(
      apiGetPlaysByDate: mockApiGetPlaysByDate,
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

  final List<String> tCategories = List<String>.from(
    playsByDateJson['response']['data']['categories'],
  );
  final List<SeriesData> tSeriesDataList = [];

  playsByDateJson['response']['data']['series'].forEach((item) {
    tSeriesDataList.add(SeriesDataModel.fromJson(item));
  });

  final tPlaysByDateGraphData = GraphDataModel(
    graphType: GraphType.playsByDate,
    categories: tCategories,
    seriesDataList: tSeriesDataList,
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
}
