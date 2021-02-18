import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/history/data/models/history_model.dart';
import 'package:tautulli_remote/features/history/domain/entities/history.dart';
import 'package:tautulli_remote/features/history/domain/usecases/get_history.dart';
import 'package:tautulli_remote/features/history/presentation/bloc/history_individual_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_users_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetHistory extends Mock implements GetHistory {}

class MockGetUsersTable extends Mock implements GetUsersTable {}

class MockLogging extends Mock implements Logging {}

void main() {
  HistoryIndividualBloc bloc;
  MockGetHistory mockGetHistory;
  MockGetUsersTable mockGetUsersTable;
  MockLogging mockLogging;

  setUp(() {
    mockGetHistory = MockGetHistory();
    mockGetUsersTable = MockGetUsersTable();
    mockLogging = MockLogging();

    bloc = HistoryIndividualBloc(
      getHistory: mockGetHistory,
      getUsersTable: mockGetUsersTable,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tRatingKey = 1;

  final List<History> tHistoryList = [];
  final List<History> tHistoryList25 = [];
  final List<UserTable> tUsersList = [];

  final userJson = json.decode(fixture('users_table.json'));
  final historyJson = json.decode(fixture('history.json'));

  historyJson['response']['data']['data'].forEach((item) {
    tHistoryList.add(HistoryModel.fromJson(item));
  });

  for (int i = 0; i < 25; i++) {
    historyJson['response']['data']['data'].forEach((item) {
      tHistoryList25.add(HistoryModel.fromJson(item));
    });
  }

  userJson['response']['data']['data'].forEach((item) {
    tUsersList.add(UserTableModel.fromJson(item));
  });

  void setUpSuccess(List historyList) {
    when(mockGetUsersTable(
      tautulliId: anyNamed('tautulliId'),
      grouping: anyNamed('grouping'),
      orderColumn: anyNamed('orderColumn'),
      orderDir: anyNamed('orderDir'),
      start: anyNamed('start'),
      length: anyNamed('length'),
      search: anyNamed('search'),
    )).thenAnswer((_) async => Right(tUsersList));
    when(
      mockGetHistory(
        tautulliId: tTautulliId,
        grouping: anyNamed('grouping'),
        user: anyNamed('user'),
        userId: anyNamed('userId'),
        ratingKey: anyNamed('ratingKey'),
        parentRatingKey: anyNamed('parentRatingKey'),
        grandparentRatingKey: anyNamed('grandparentRatingKey'),
        startDate: anyNamed('startDate'),
        sectionId: anyNamed('sectionId'),
        mediaType: anyNamed('mediaType'),
        transcodeDecision: anyNamed('transcodeDecision'),
        guid: anyNamed('guid'),
        orderColumn: anyNamed('orderColumn'),
        orderDir: anyNamed('orderDir'),
        start: anyNamed('start'),
        length: anyNamed('length'),
        search: anyNamed('search'),
      ),
    ).thenAnswer((_) async => Right(historyList));
  }

  test(
    'initialState should be HistoryIndividualInitial',
    () async {
      // assert
      expect(bloc.state, HistoryIndividualInitial());
    },
  );

  group('HistoryIndividualFetch', () {
    test(
      'should get data from GetHistory use case',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        // act
        bloc.add(
          HistoryIndividualFetch(
            tautulliId: tTautulliId,
            userId: null,
          ),
        );
        await untilCalled(
          mockGetHistory(
            tautulliId: tTautulliId,
            grouping: anyNamed('grouping'),
            user: anyNamed('user'),
            userId: anyNamed('userId'),
            ratingKey: anyNamed('ratingKey'),
            parentRatingKey: anyNamed('parentRatingKey'),
            grandparentRatingKey: anyNamed('grandparentRatingKey'),
            startDate: anyNamed('startDate'),
            sectionId: anyNamed('sectionId'),
            mediaType: anyNamed('mediaType'),
            transcodeDecision: anyNamed('transcodeDecision'),
            guid: anyNamed('guid'),
            orderColumn: anyNamed('orderColumn'),
            orderDir: anyNamed('orderDir'),
            start: anyNamed('start'),
            length: anyNamed('length'),
            search: anyNamed('search'),
          ),
        );
        // assert
        verify(mockGetHistory(
          tautulliId: tTautulliId,
          grouping: anyNamed('grouping'),
          user: anyNamed('user'),
          userId: anyNamed('userId'),
          ratingKey: anyNamed('ratingKey'),
          parentRatingKey: anyNamed('parentRatingKey'),
          grandparentRatingKey: anyNamed('grandparentRatingKey'),
          startDate: anyNamed('startDate'),
          sectionId: anyNamed('sectionId'),
          mediaType: anyNamed('mediaType'),
          transcodeDecision: anyNamed('transcodeDecision'),
          guid: anyNamed('guid'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
        ));
      },
    );

    test(
      'should emit [HistoryIndividualSuccess] with hasReachedMax as false when data is fetched successfully and list is 25 or more',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        // assert later
        final expected = [
          HistoryIndividualInProgress(),
          HistoryIndividualSuccess(
            list: tHistoryList25,
            userTableList: tUsersList,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryIndividualFetch(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );

    test(
      'should emit [HistoryIndividualFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        clearCache();
        when(
          mockGetHistory(
            tautulliId: tTautulliId,
            grouping: anyNamed('grouping'),
            user: anyNamed('user'),
            userId: anyNamed('userId'),
            ratingKey: anyNamed('ratingKey'),
            parentRatingKey: anyNamed('parentRatingKey'),
            grandparentRatingKey: anyNamed('grandparentRatingKey'),
            startDate: anyNamed('startDate'),
            sectionId: anyNamed('sectionId'),
            mediaType: anyNamed('mediaType'),
            transcodeDecision: anyNamed('transcodeDecision'),
            guid: anyNamed('guid'),
            orderColumn: anyNamed('orderColumn'),
            orderDir: anyNamed('orderDir'),
            start: anyNamed('start'),
            length: anyNamed('length'),
            search: anyNamed('search'),
          ),
        ).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          HistoryIndividualInProgress(),
          HistoryIndividualFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryIndividualFetch(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );

    test(
      'when state is [HistoryIndividualSuccess] should emit [HistoryIndividualSuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        bloc.emit(
          HistoryIndividualSuccess(
            list: tHistoryList25,
            userTableList: tUsersList,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          HistoryIndividualSuccess(
            list: tHistoryList25 + tHistoryList25,
            userTableList: tUsersList,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryIndividualFetch(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );

    test(
      'when state is [HistoryIndividualSuccess] should emit [HistoryIndividualSuccess] with hasReachedMax as true when data is fetched successfully and less then 25',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        bloc.emit(
          HistoryIndividualSuccess(
            list: tHistoryList,
            userTableList: tUsersList,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          HistoryIndividualSuccess(
            list: tHistoryList + tHistoryList,
            userTableList: tUsersList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryIndividualFetch(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );
  });
}
