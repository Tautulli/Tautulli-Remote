import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote_tdd/features/recent/domain/entities/recent.dart';
import 'package:tautulli_remote_tdd/features/recent/domain/usecases/get_recently_added.dart';
import 'package:tautulli_remote_tdd/features/recent/presentation/bloc/recently_added_bloc.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetRecentlyAdded extends Mock implements GetRecentlyAdded {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockLogging extends Mock implements Logging {}

void main() {
  RecentlyAddedBloc bloc;
  MockGetRecentlyAdded mockGetRecentlyAdded;
  MockGetImageUrl mockGetImageUrl;
  MockLogging mockLogging;

  setUp(() {
    mockGetRecentlyAdded = MockGetRecentlyAdded();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();
    bloc = RecentlyAddedBloc(
      recentlyAdded: mockGetRecentlyAdded,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tTautulliId2 = 'mno';
  final tCount = 10;

  final List<RecentItem> tRecentList = [];

  final recentJson = json.decode(fixture('recent.json'));

  recentJson['response']['data']['recently_added'].forEach((item) {
    tRecentList.add(RecentItemModel.fromJson(item));
  });

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.wreave.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetRecentlyAdded(
        tautulliId: anyNamed('tautulliId'),
        count: anyNamed('count'),
        start: anyNamed('start'),
        mediaType: anyNamed('mediaType'),
        sectionId: anyNamed('sectionId'),
      ),
    ).thenAnswer((_) async => Right(tRecentList));
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
  }

  void setUpEmptySuccess() {
    String imageUrl =
        'https://tautulli.wreave.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetRecentlyAdded(
        tautulliId: anyNamed('tautulliId'),
        count: anyNamed('count'),
        start: anyNamed('start'),
        mediaType: anyNamed('mediaType'),
        sectionId: anyNamed('sectionId'),
      ),
    ).thenAnswer((_) async => Right([]));
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
  }

  test(
    'initialState should be RecentlyAddedInitial',
    () async {
      // assert
      expect(bloc.state, RecentlyAddedInitial());
    },
  );

  group('RecentlyAddedFetched', () {
    test(
      'should get data from GetRecentlyAdded use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(RecentlyAddedFetched(tautulliId: tTautulliId));
        await untilCalled(mockGetRecentlyAdded(
          tautulliId: anyNamed('tautulliId'),
          count: anyNamed('count'),
          start: anyNamed('start'),
          mediaType: anyNamed('mediaType'),
          sectionId: anyNamed('sectionId'),
        ));
        // assert
        verify(
          mockGetRecentlyAdded(
            tautulliId: tTautulliId,
            count: tCount,
          ),
        );
      },
    );

    test(
      'should get data from the GetImageUrl use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(RecentlyAddedFetched(tautulliId: tTautulliId));
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
            tautulliId: anyNamed('tautulliId'),
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
          ),
        );
      },
    );

    test(
      'should emit [RecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          RecentlyAddedSuccess(
            list: tRecentList,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(RecentlyAddedFetched(tautulliId: tTautulliId));
      },
    );

    test(
      'should emit [RecentlyAddedFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        when(
          mockGetRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
          ),
        ).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          RecentlyAddedFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(RecentlyAddedFetched(tautulliId: tTautulliId));
      },
    );

    test(
      'when state is [RecentlyAddedSuccess] should emit [RecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        bloc.emit(
          RecentlyAddedSuccess(
            list: tRecentList,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          RecentlyAddedSuccess(
            list: tRecentList + tRecentList,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(RecentlyAddedFetched(tautulliId: tTautulliId));
      },
    );

    test(
      'when state is [RecentlyAddedSuccess] should emit [RecentlyAddedSuccess] with hasReachedMax as true when data is fetched successfully and empty',
      () async {
        // arrange
        setUpEmptySuccess();
        bloc.emit(
          RecentlyAddedSuccess(
            list: tRecentList,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          RecentlyAddedSuccess(
            list: tRecentList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(RecentlyAddedFetched(tautulliId: tTautulliId));
      },
    );
  });

  group('RecentlyAddedLoadNewServer', () {
    test(
      'should emit [RecentlyAddedInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          RecentlyAddedInitial(),
          RecentlyAddedSuccess(
            list: tRecentList,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(RecentlyAddedLoadNewServer(tautulliId: tTautulliId2));
      },
    );
  });
}
