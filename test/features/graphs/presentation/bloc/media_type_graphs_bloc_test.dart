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
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_date.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_day_of_week.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_hour_of_day.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_top_10_platforms.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_top_10_users.dart';
import 'package:tautulli_remote/features/graphs/presentation/bloc/media_type_graphs_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysByDate extends Mock implements GetPlaysByDate {}

class MockGetPlaysByDayOfWeek extends Mock implements GetPlaysByDayOfWeek {}

class MockGetPlaysByHourOfDay extends Mock implements GetPlaysByHourOfDay {}

class MockGetPlaysByTop10Platforms extends Mock
    implements GetPlaysByTop10Platforms {}

class MockGetPlaysByTop10Users extends Mock implements GetPlaysByTop10Users {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  MediaTypeGraphsBloc bloc;
  MockGetPlaysByDate mockGetPlaysByDate;
  MockGetPlaysByDayOfWeek mockGetPlaysByDayOfWeek;
  MockGetPlaysByHourOfDay mockGetPlaysByHourOfDay;
  MockGetPlaysByTop10Platforms mockGetPlaysByTop10Platforms;
  MockGetPlaysByTop10Users mockGetPlaysByTop10Users;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetPlaysByDate = MockGetPlaysByDate();
    mockGetPlaysByDayOfWeek = MockGetPlaysByDayOfWeek();
    mockGetPlaysByHourOfDay = MockGetPlaysByHourOfDay();
    mockGetPlaysByTop10Platforms = MockGetPlaysByTop10Platforms();
    mockGetPlaysByTop10Users = MockGetPlaysByTop10Users();
    mockLogging = MockLogging();
    bloc = MediaTypeGraphsBloc(
      getPlaysByDate: mockGetPlaysByDate,
      getPlaysByDayOfWeek: mockGetPlaysByDayOfWeek,
      getPlaysByHourOfDay: mockGetPlaysByHourOfDay,
      getPlaysByTop10Platforms: mockGetPlaysByTop10Platforms,
      getPlaysByTop10Users: mockGetPlaysByTop10Users,
      logging: mockLogging,
    );
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
    when(mockGetPlaysByHourOfDay(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByHourOfDayGraphData));
    when(mockGetPlaysByTop10Platforms(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByTop10PlatformsGraphData));
    when(mockGetPlaysByTop10Users(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByTop10UsersGraphData));
  }

  MediaTypeGraphsLoaded loadingState() {
    final playsByDateGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByDate,
    );
    final playsByDayOfWeekGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByDayOfWeek,
    );
    final playsByHourOfDayGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByHourOfDay,
    );
    final playsByTop10PlatformsGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByTop10Platforms,
    );
    final playsByTop10UsersGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByTop10Users,
    );
    final currentState = MediaTypeGraphsLoaded(
      playsByDate: playsByDateGraphState,
      playsByDayOfWeek: playsByDayOfWeekGraphState,
      playsByHourOfDay: playsByHourOfDayGraphState,
      playsByTop10Platforms: playsByTop10PlatformsGraphState,
      playsByTop10Users: playsByTop10UsersGraphState,
    );

    return currentState;
  }

  test(
    'initialState should be MediaTypeGraphsInitial',
    () async {
      // assert
      expect(bloc.state, MediaTypeGraphsInitial());
    },
  );

  group('MediaTypeGraphsFetch', () {
    test(
      'should get data from GetPlaysByDate use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          MediaTypeGraphsFetch(
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
          MediaTypeGraphsFetch(
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

    test(
      'should get data from GetPlaysByHourOfDay use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          MediaTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByHourOfDay(
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
          mockGetPlaysByHourOfDay(
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
      'should get data from GetPlaysByTop10Platforms use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          MediaTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByTop10Platforms(
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
          mockGetPlaysByTop10Platforms(
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
      'should get data from GetPlaysByTop10Users use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          MediaTypeGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByTop10Users(
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
          mockGetPlaysByTop10Users(
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

  group('MediaTypeGraphsLoadPlaysByDate', () {
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
              graphType: GraphType.playsByDate,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          MediaTypeGraphsLoadPlaysByDate(
            tautulliId: tTautulliId,
            failureOrPlaysByDate: Right(tPlaysByDateGraphData),
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
              graphType: GraphType.playsByDate,
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
          MediaTypeGraphsLoadPlaysByDate(
            tautulliId: tTautulliId,
            failureOrPlaysByDate: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('MediaTypeGraphsLoadPlaysByDayOfWeek', () {
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
              graphType: GraphType.playsByDayOfWeek,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          MediaTypeGraphsLoadPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            failureOrPlaysByDayOfWeek: Right(tPlaysByDayOfWeekGraphData),
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
              graphType: GraphType.playsByDayOfWeek,
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
          MediaTypeGraphsLoadPlaysByDayOfWeek(
            tautulliId: tTautulliId,
            failureOrPlaysByDayOfWeek: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('MediaTypeGraphsLoadPlaysByHourOfDay', () {
    test(
      'should emit [PlaysGraphLoaded] with playsByHourOfDay graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByHourOfDay: GraphState(
              graphData: tPlaysByHourOfDayGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsByHourOfDay,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          MediaTypeGraphsLoadPlaysByHourOfDay(
            tautulliId: tTautulliId,
            failureOrPlaysByHourOfDay: Right(tPlaysByHourOfDayGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [PlaysGraphLoaded] with playsByHourOfDay graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByHourOfDay: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsByHourOfDay,
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
          MediaTypeGraphsLoadPlaysByHourOfDay(
            tautulliId: tTautulliId,
            failureOrPlaysByHourOfDay: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('MediaTypeGraphsLoadPlaysByTop10Platforms', () {
    test(
      'should emit [PlaysGraphLoaded] with playsByTop10Platforms graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByTop10Platforms: GraphState(
              graphData: tPlaysByTop10PlatformsGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsByTop10Platforms,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          MediaTypeGraphsLoadPlaysByTop10Platforms(
            tautulliId: tTautulliId,
            failureOrPlaysByTop10Platforms:
                Right(tPlaysByTop10PlatformsGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [PlaysGraphLoaded] with playsByTop10Platforms graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByTop10Platforms: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsByTop10Platforms,
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
          MediaTypeGraphsLoadPlaysByTop10Platforms(
            tautulliId: tTautulliId,
            failureOrPlaysByTop10Platforms: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });

  group('MediaTypeGraphsLoadPlaysByTop10Users', () {
    test(
      'should emit [PlaysGraphLoaded] with playsByTop10Users graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByTop10Users: GraphState(
              graphData: tPlaysByTop10UsersGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsByTop10Users,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          MediaTypeGraphsLoadPlaysByTop10Users(
            tautulliId: tTautulliId,
            failureOrPlaysByTop10Users: Right(tPlaysByTop10UsersGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [PlaysGraphLoaded] with playsByTop10Users graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByTop10Users: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsByTop10Users,
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
          MediaTypeGraphsLoadPlaysByTop10Users(
            tautulliId: tTautulliId,
            failureOrPlaysByTop10Users: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });
}
