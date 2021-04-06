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
    graphData: tSeriesDataList,
  );

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
}
