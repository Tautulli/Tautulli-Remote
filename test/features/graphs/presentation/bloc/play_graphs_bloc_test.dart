import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_data.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_state.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_date.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_day_of_week.dart';
import 'package:tautulli_remote/features/graphs/presentation/bloc/play_graphs_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysByDate extends Mock implements GetPlaysByDate {}

class MockGetPlaysByDayOfWeek extends Mock implements GetPlaysByDayOfWeek {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  PlayGraphsBloc bloc;
  MockGetPlaysByDate mockGetPlaysByDate;
  MockGetPlaysByDayOfWeek mockGetPlaysByDayOfWeek;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetPlaysByDate = MockGetPlaysByDate();
    mockGetPlaysByDayOfWeek = MockGetPlaysByDayOfWeek();
    mockLogging = MockLogging();
    bloc = PlayGraphsBloc(
      getPlaysByDate: mockGetPlaysByDate,
      getPlaysByDayOfWeek: mockGetPlaysByDayOfWeek,
      logging: mockLogging,
    );
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const String tYAxis = 'duration';

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
    graphType: GraphType.playsByDayOfWeek,
    categories: tPlaysByDayOfWeekCategories,
    seriesDataList: tPlaysByDayOfWeekSeriesDataList,
  );

  void setUpSuccess() {
    when(mockGetPlaysByDate(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByDateGraphData));
    when(mockGetPlaysByDayOfWeek(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByDayOfWeekGraphData));
  }

  PlayGraphsLoaded loadingState() {
    final playsByDateGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
    );
    final playsByDayOfWeekGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
    );
    final currentState = PlayGraphsLoaded(
      playsByDate: playsByDateGraphState,
      playsByDayOfWeek: playsByDayOfWeekGraphState,
    );

    return currentState;
  }

  test(
    'initialState should be PlayGraphsInitial',
    () async {
      // assert
      expect(bloc.state, PlayGraphsInitial());
    },
  );

  group('PlayGraphsFetch', () {
    test(
      'should get data from GetPlaysByDate use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          PlayGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByDate(
            tautulliId: anyNamed('tautulliId'),
            timeRange: anyNamed('timeRange'),
            yAxis: anyNamed('yAxis'),
            userId: anyNamed('userId'),
            grouping: anyNamed('grouping'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockGetPlaysByDate(
            tautulliId: anyNamed('tautulliId'),
            timeRange: anyNamed('timeRange'),
            yAxis: anyNamed('yAxis'),
            userId: anyNamed('userId'),
            grouping: anyNamed('grouping'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );

    test(
      'should get data from GetPlaysByDayOfWeek use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          PlayGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByDayOfWeek(
            tautulliId: anyNamed('tautulliId'),
            timeRange: anyNamed('timeRange'),
            yAxis: anyNamed('yAxis'),
            userId: anyNamed('userId'),
            grouping: anyNamed('grouping'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockGetPlaysByDayOfWeek(
            tautulliId: anyNamed('tautulliId'),
            timeRange: anyNamed('timeRange'),
            yAxis: anyNamed('yAxis'),
            userId: anyNamed('userId'),
            grouping: anyNamed('grouping'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );
  });

  group('PlayGraphsLoadPlaysByDate', () {
    test(
      'should emit [PlaysGraphLoaded] with playsByDate graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByDate: GraphState(
              graphData: tPlaysByDateGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          PlayGraphsLoadPlaysByDate(
            tautulliId: tTautulliId,
            failureOrPlayByDate: Right(tPlaysByDateGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [PlaysGraphLoaded] with playsByDate graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByDate: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              failureMessage: FailureMapperHelper.mapFailureToMessage(failure),
              failureSuggestion:
                  FailureMapperHelper.mapFailureToSuggestion(failure),
              failure: failure,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          PlayGraphsLoadPlaysByDate(
            tautulliId: tTautulliId,
            failureOrPlayByDate: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('PlayGraphsLoadPlaysByDayOfWeek', () {
    test(
      'should emit [PlaysGraphLoaded] with playsByDayOfWeek graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByDayOfWeek: GraphState(
              graphData: tPlaysByDayOfWeekGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          PlayGraphsLoadPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            failureOrPlayByDayOfWeek: Right(tPlaysByDayOfWeekGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [PlaysGraphLoaded] with playsByDayOfWeek graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByDayOfWeek: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              failureMessage: FailureMapperHelper.mapFailureToMessage(failure),
              failureSuggestion:
                  FailureMapperHelper.mapFailureToSuggestion(failure),
              failure: failure,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          PlayGraphsLoadPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            failureOrPlayByDayOfWeek: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });
}
