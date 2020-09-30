import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/features/history/data/models/history_model.dart';
import 'package:tautulli_remote_tdd/features/history/domain/entities/history.dart';
import 'package:tautulli_remote_tdd/features/history/domain/usecases/get_history.dart';
import 'package:tautulli_remote_tdd/features/history/presentation/bloc/history_bloc.dart';
import 'package:tautulli_remote_tdd/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetHistory extends Mock implements GetHistory {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockLogging extends Mock implements Logging {}

void main() {
  HistoryBloc bloc;
  MockGetHistory mockGetHistory;
  MockGetImageUrl mockGetImageUrl;
  MockLogging mockLogging;

  setUp(() {
    mockGetHistory = MockGetHistory();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();
    bloc = HistoryBloc(
      getHistory: mockGetHistory,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tMediaType = 'all';

  final List<History> tHistoryList = [];
  final List<History> tHistoryList25 = [];

  final historyJson = json.decode(fixture('history.json'));
  historyJson['response']['data']['data'].forEach((item) {
    tHistoryList.add(HistoryModel.fromJson(item));
  });

  for (int i = 0; i < 25; i++) {
    historyJson['response']['data']['data'].forEach((item) {
      tHistoryList25.add(HistoryModel.fromJson(item));
    });
  }

  void setUpSuccess(List historyList) {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
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
    'initialState should be HistoryInitial',
    () async {
      // assert
      expect(bloc.state, HistoryInitial());
    },
  );

  group('HistoryFetch', () {
    test(
      'should get data from GetHistory use case',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        // act
        bloc.add(
          HistoryFetch(
            tautulliId: tTautulliId,
            userId: null,
            mediaType: tMediaType,
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
          mediaType: tMediaType,
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
      'should get data from the ImageUrl use case',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        // act
        bloc.add(
          HistoryFetch(
            tautulliId: tTautulliId,
            userId: null,
            mediaType: tMediaType,
          ),
        );
        await untilCalled(
          mockGetImageUrl(
            tautulliId: anyNamed('tautulliId'),
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
          ),
        );
        // assert
        verify(
          mockGetImageUrl(
            tautulliId: tTautulliId,
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
          ),
        );
      },
    );

    test(
      'should emit [HistorySuccess] with hasReachedMax as false when data is fetched successfully and list is 25 or more',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        // assert later
        final expected = [
          HistorySuccess(
            list: tHistoryList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryFetch(
          tautulliId: tTautulliId,
          mediaType: tMediaType,
        ));
      },
    );

    test(
      'should emit [HistoryFailure] with a proper message when getting data fails',
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
            mediaType: tMediaType,
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
          HistoryFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryFetch(
          tautulliId: tTautulliId,
          mediaType: tMediaType,
        ));
      },
    );

    test(
      'when state is [HistorySuccess] should emit [HistorySuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        bloc.emit(
          HistorySuccess(
            list: tHistoryList25,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          HistorySuccess(
            list: tHistoryList25 + tHistoryList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryFetch(
          tautulliId: tTautulliId,
          mediaType: tMediaType,
        ));
      },
    );

    test(
      'when state is [HistorySuccess] should emit [HistorySuccess] with hasReachedMax as true when data is fetched successfully and less then 25',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        bloc.emit(
          HistorySuccess(
            list: tHistoryList,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          HistorySuccess(
            list: tHistoryList + tHistoryList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryFetch(
          tautulliId: tTautulliId,
          mediaType: tMediaType,
        ));
      },
    );
  });

  group('HistoryFilter', () {
    test(
      'should emit [HistoryInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        // assert later
        final expected = [
          HistoryInitial(),
          HistorySuccess(
            list: tHistoryList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(HistoryFilter(
          tautulliId: tTautulliId,
          mediaType: tMediaType,
        ));
      },
    );
  });
}
