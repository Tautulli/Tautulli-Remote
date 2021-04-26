import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_state.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_source_resolution.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_stream_resolution.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_stream_type.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_stream_type_by_top_10_platforms.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_stream_type_by_top_10_users.dart';
import 'package:tautulli_remote/features/graphs/presentation/bloc/stream_type_graphs_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysByStreamType extends Mock implements GetPlaysByStreamType {}

class MockGetPlaysBySourceResolution extends Mock
    implements GetPlaysBySourceResolution {}

class MockGetPlaysByStreamResolution extends Mock
    implements GetPlaysByStreamResolution {}

class MockGetStreamTypeByTop10Platforms extends Mock
    implements GetStreamTypeByTop10Platforms {}

class MockGetStreamTypeByTop10Users extends Mock
    implements GetStreamTypeByTop10Users {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  StreamTypeGraphsBloc bloc;
  MockGetPlaysByStreamType mockGetPlaysByStreamType;
  MockGetPlaysBySourceResolution mockGetPlaysBySourceResolution;
  MockGetPlaysByStreamResolution mockGetPlaysByStreamResolution;
  MockGetStreamTypeByTop10Platforms mockGetStreamTypeByTop10Platforms;
  MockGetStreamTypeByTop10Users mockGetStreamTypeByTop10Users;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetPlaysByStreamType = MockGetPlaysByStreamType();
    mockGetPlaysBySourceResolution = MockGetPlaysBySourceResolution();
    mockGetPlaysByStreamResolution = MockGetPlaysByStreamResolution();
    mockGetStreamTypeByTop10Platforms = MockGetStreamTypeByTop10Platforms();
    mockGetStreamTypeByTop10Users = MockGetStreamTypeByTop10Users();
    mockLogging = MockLogging();
    bloc = StreamTypeGraphsBloc(
      getPlaysByStreamType: mockGetPlaysByStreamType,
      getPlaysBySourceResolution: mockGetPlaysBySourceResolution,
      getPlaysByStreamResolution: mockGetPlaysByStreamResolution,
      getStreamTypeByTop10Platforms: mockGetStreamTypeByTop10Platforms,
      getStreamTypeByTop10Users: mockGetStreamTypeByTop10Users,
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

  void setUpSuccess() {
    when(mockGetPlaysByStreamType(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByStreamTypeGraphData));
    when(mockGetPlaysBySourceResolution(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysBySourceResolutionGraphData));
    when(mockGetPlaysByStreamResolution(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByStreamResolutionGraphData));
    when(mockGetStreamTypeByTop10Platforms(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tStreamTypeByTop10PlatformsGraphData));
    when(mockGetStreamTypeByTop10Users(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tStreamTypeByTop10UsersGraphData));
  }

  StreamTypeGraphsLoaded loadingState() {
    final playsByStreamTypeGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByStreamType,
    );
    final playsBySourceResolutionGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsBySourceResolution,
    );
    final playsByStreamResolutionGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByStreamResolution,
    );
    final streamTypeByTop10PlatformsGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.streamTypeByTop10Platforms,
    );
    final streamTypeByTop10UsersGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.streamTypeByTop10Users,
    );
    final currentState = StreamTypeGraphsLoaded(
      playsByStreamType: playsByStreamTypeGraphState,
      playsBySourceResolution: playsBySourceResolutionGraphState,
      playsByStreamResolution: playsByStreamResolutionGraphState,
      streamTypeByTop10Platforms: streamTypeByTop10PlatformsGraphState,
      streamTypeByTop10Users: streamTypeByTop10UsersGraphState,
    );

    return currentState;
  }

  test(
    'initialState should be StreamTypeGraphsInitial',
    () async {
      // assert
      expect(bloc.state, StreamTypeGraphsInitial());
    },
  );

  group('StreamTypeGraphsFetch', () {
    test(
      'should get data from GetPlaysByStreamType use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          StreamTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByStreamType(
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
          mockGetPlaysByStreamType(
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
      'should get data from GetPlaysBySourceResolution use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          StreamTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysBySourceResolution(
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
          mockGetPlaysBySourceResolution(
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
      'should get data from GetPlaysByStreamResolution use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          StreamTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByStreamResolution(
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
          mockGetPlaysByStreamResolution(
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
      'should get data from GetStreamTypeByTop10Platforms use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          StreamTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetStreamTypeByTop10Platforms(
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
          mockGetStreamTypeByTop10Platforms(
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
      'should get data from GetStreamTypeByTop10Users use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          StreamTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetStreamTypeByTop10Users(
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
          mockGetStreamTypeByTop10Users(
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

  group('StreamTypeGraphsLoadPlaysByStreamType', () {
    test(
      'should emit [StreamTypeGraphLoaded] with playsByStreamType graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByStreamType: GraphState(
              graphData: tPlaysByStreamTypeGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsByStreamType,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamTypeGraphsLoadPlaysByStreamType(
            tautulliId: tTautulliId,
            failureOrPlaysByStreamType: Right(tPlaysByStreamTypeGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [StreamTypeGraphLoaded] with playsByStreamType graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByStreamType: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsByStreamType,
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
          StreamTypeGraphsLoadPlaysByStreamType(
            tautulliId: tTautulliId,
            failureOrPlaysByStreamType: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('StreamTypeGraphsLoadPlaysBySourceResolution', () {
    test(
      'should emit [StreamTypeGraphLoaded] with playsBySourceResolution graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsBySourceResolution: GraphState(
              graphData: tPlaysBySourceResolutionGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsBySourceResolution,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamTypeGraphsLoadPlaysBySourceResolution(
            tautulliId: tTautulliId,
            failureOrPlaysBySourceResolution:
                Right(tPlaysBySourceResolutionGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [StreamTypeGraphLoaded] with playsBySourceResolution graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsBySourceResolution: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsBySourceResolution,
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
          StreamTypeGraphsLoadPlaysBySourceResolution(
            tautulliId: tTautulliId,
            failureOrPlaysBySourceResolution: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('StreamTypeGraphsLoadPlaysByStreamResolution', () {
    test(
      'should emit [StreamTypeGraphLoaded] with playsByStreamResolution graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByStreamResolution: GraphState(
              graphData: tPlaysByStreamResolutionGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsByStreamResolution,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamTypeGraphsLoadPlaysByStreamResolution(
            tautulliId: tTautulliId,
            failureOrPlaysByStreamResolution:
                Right(tPlaysByStreamResolutionGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [StreamTypeGraphLoaded] with playsByStreamResolution graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByStreamResolution: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsByStreamResolution,
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
          StreamTypeGraphsLoadPlaysByStreamResolution(
            tautulliId: tTautulliId,
            failureOrPlaysByStreamResolution: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('StreamTypeGraphsLoadStreamTypeByTop10Platforms', () {
    test(
      'should emit [StreamTypeGraphLoaded] with streamTypeByTop10Platforms graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            streamTypeByTop10Platforms: GraphState(
              graphData: tStreamTypeByTop10PlatformsGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.streamTypeByTop10Platforms,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamTypeGraphsLoadStreamTypeByTop10Platforms(
            tautulliId: tTautulliId,
            failureOrStreamTypeByTop10Platforms:
                Right(tStreamTypeByTop10PlatformsGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [StreamTypeGraphLoaded] with playsByStreamResolution graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            streamTypeByTop10Platforms: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.streamTypeByTop10Platforms,
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
          StreamTypeGraphsLoadStreamTypeByTop10Platforms(
            tautulliId: tTautulliId,
            failureOrStreamTypeByTop10Platforms: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('StreamTypeGraphsLoadStreamTypeByTop10Users', () {
    test(
      'should emit [StreamTypeGraphLoaded] with streamTypeByTop10Users graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            streamTypeByTop10Users: GraphState(
              graphData: tStreamTypeByTop10UsersGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.streamTypeByTop10Users,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamTypeGraphsLoadStreamTypeByTop10Users(
            tautulliId: tTautulliId,
            failureOrStreamTypeByTop10Users:
                Right(tStreamTypeByTop10UsersGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [StreamTypeGraphLoaded] with playsByStreamResolution graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            streamTypeByTop10Users: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.streamTypeByTop10Users,
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
          StreamTypeGraphsLoadStreamTypeByTop10Users(
            tautulliId: tTautulliId,
            failureOrStreamTypeByTop10Users: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });
}
