import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';
import 'package:tautulli_remote/features/recent/domain/usecases/get_recently_added.dart';
import 'package:tautulli_remote/features/recent/presentation/bloc/recently_added_bloc.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetRecentlyAdded extends Mock implements GetRecentlyAdded {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  RecentlyAddedBloc bloc;
  MockGetRecentlyAdded mockGetRecentlyAdded;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetRecentlyAdded = MockGetRecentlyAdded();
    mockGetImageUrl = MockGetImageUrl();
    bloc = RecentlyAddedBloc(
      recentlyAdded: mockGetRecentlyAdded,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tTautulliId2 = 'mno';
  final tCount = 25;
  final tMediaType = 'all';
  final tMediaType2 = 'movie';
  String imageUrl =
      'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';

  final List<RecentItem> tRecentList = [];
  final List<RecentItem> tRecentListWithImages = [];
  final List<RecentItem> tRecentList27 = [];
  final List<RecentItem> tRecentList27WithImages = [];

  final recentJson = json.decode(fixture('recent.json'));

  recentJson['response']['data']['recently_added'].forEach((item) {
    tRecentList.add(RecentItemModel.fromJson(item));
  });

  for (RecentItem item in tRecentList) {
    tRecentListWithImages.add(item.copyWith(posterUrl: imageUrl));
  }

  for (int i = 0; i < 9; i++) {
    recentJson['response']['data']['recently_added'].forEach((item) {
      tRecentList27.add(RecentItemModel.fromJson(item));
    });
  }

  for (RecentItem item in tRecentList27) {
    tRecentList27WithImages.add(item.copyWith(posterUrl: imageUrl));
  }

  void setUpSuccess(List recentList) {
    when(
      mockGetRecentlyAdded(
        tautulliId: anyNamed('tautulliId'),
        count: anyNamed('count'),
        start: anyNamed('start'),
        mediaType: anyNamed('mediaType'),
        sectionId: anyNamed('sectionId'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(recentList));
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
        settingsBloc: anyNamed('settingsBloc'),
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
    group('media type is all', () {
      test(
        'should get data from GetRecentlyAdded use case',
        () async {
          // arrange
          setUpSuccess(tRecentList);
          clearCache();
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType,
            settingsBloc: settingsBloc,
          ));
          await untilCalled(mockGetRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ));
          // assert
          verify(
            mockGetRecentlyAdded(
              tautulliId: tTautulliId,
              count: 50,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should get data from the GetImageUrl use case',
        () async {
          // arrange
          setUpSuccess(tRecentList);
          clearCache();
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
          await untilCalled(
            mockGetImageUrl(
              tautulliId: anyNamed('tautulliId'),
              img: anyNamed('img'),
              ratingKey: anyNamed('ratingKey'),
              fallback: anyNamed('fallback'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          );
          // assert
          verify(
            mockGetImageUrl(
              tautulliId: anyNamed('tautulliId'),
              img: anyNamed('img'),
              ratingKey: anyNamed('ratingKey'),
              fallback: anyNamed('fallback'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          );
        },
      );

      test(
        'should emit [RecentlyAddedFailure] with a proper message when getting data fails',
        () async {
          // arrange
          final failure = ServerFailure();
          clearCache();
          when(
            mockGetRecentlyAdded(
              tautulliId: anyNamed('tautulliId'),
              count: anyNamed('count'),
              start: anyNamed('start'),
              mediaType: anyNamed('mediaType'),
              sectionId: anyNamed('sectionId'),
              settingsBloc: anyNamed('settingsBloc'),
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
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
        },
      );
    });

    group('media type is movie, show, artist, other_video', () {
      test(
        'should get data from GetRecentlyAdded use case',
        () async {
          // arrange
          setUpSuccess(tRecentList);
          clearCache();
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
          await untilCalled(mockGetRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ));
          // assert
          verify(
            mockGetRecentlyAdded(
              tautulliId: tTautulliId,
              count: tCount,
              mediaType: tMediaType2,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should get data from the GetImageUrl use case',
        () async {
          // arrange
          setUpSuccess(tRecentList);
          clearCache();
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
          await untilCalled(
            mockGetImageUrl(
              tautulliId: anyNamed('tautulliId'),
              img: anyNamed('img'),
              ratingKey: anyNamed('ratingKey'),
              fallback: anyNamed('fallback'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          );
          // assert
          verify(
            mockGetImageUrl(
              tautulliId: anyNamed('tautulliId'),
              img: anyNamed('img'),
              ratingKey: anyNamed('ratingKey'),
              fallback: anyNamed('fallback'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          );
        },
      );

      test(
        'should emit [RecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully and list is 10 or more',
        () async {
          // arrange
          setUpSuccess(tRecentList27);
          clearCache();
          clearCache();
          // assert later
          final expected = [
            RecentlyAddedSuccess(
              list: tRecentList27WithImages,
              hasReachedMax: false,
            ),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
        },
      );

      test(
        'should emit [RecentlyAddedFailure] with a proper message when getting data fails',
        () async {
          // arrange
          final failure = ServerFailure();
          clearCache();
          when(
            mockGetRecentlyAdded(
              tautulliId: anyNamed('tautulliId'),
              count: anyNamed('count'),
              start: anyNamed('start'),
              mediaType: anyNamed('mediaType'),
              sectionId: anyNamed('sectionId'),
              settingsBloc: anyNamed('settingsBloc'),
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
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
        },
      );

      test(
        'when state is [RecentlyAddedSuccess] should emit [RecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully',
        () async {
          // arrange
          setUpSuccess(tRecentList27);
          clearCache();
          bloc.emit(
            RecentlyAddedSuccess(
              list: tRecentList27WithImages,
              hasReachedMax: false,
            ),
          );
          // assert later
          final expected = [
            RecentlyAddedSuccess(
              list: tRecentList27WithImages + tRecentList27WithImages,
              hasReachedMax: false,
            ),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
        },
      );

      test(
        'when state is [RecentlyAddedSuccess] should emit [RecentlyAddedSuccess] with hasReachedMax as true when data is fetched successfully and less then 10',
        () async {
          // arrange
          setUpSuccess(tRecentList);
          clearCache();
          bloc.emit(
            RecentlyAddedSuccess(
              list: tRecentListWithImages,
              hasReachedMax: false,
            ),
          );
          // assert later
          final expected = [
            RecentlyAddedSuccess(
              list: tRecentListWithImages + tRecentListWithImages,
              hasReachedMax: true,
            ),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(RecentlyAddedFetched(
            tautulliId: tTautulliId,
            mediaType: tMediaType2,
            settingsBloc: settingsBloc,
          ));
        },
      );
    });
  });

  group('RecentlyAddedFilter', () {
    test(
      'should emit [RecentlyAddedInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess(tRecentList27);
        // assert later
        final expected = [
          RecentlyAddedInitial(),
          RecentlyAddedSuccess(
            list: tRecentList27WithImages,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(RecentlyAddedFilter(
          tautulliId: tTautulliId2,
          mediaType: tMediaType2,
        ));
      },
    );
  });
}
