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
import 'package:tautulli_remote/features/recent/presentation/bloc/libraries_recently_added_bloc.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetRecentlyAdded extends Mock implements GetRecentlyAdded {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibrariesRecentlyAddedBloc bloc;
  MockGetRecentlyAdded mockGetRecentlyAdded;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetRecentlyAdded = MockGetRecentlyAdded();
    mockGetImageUrl = MockGetImageUrl();
    bloc = LibrariesRecentlyAddedBloc(
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
  final tCount = 25;
  final tSectionId = 1;
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
    'initialState should be LibrariesRecentlyAddedInitial',
    () async {
      // assert
      expect(bloc.state, LibrariesRecentlyAddedInitial());
    },
  );

  group('LibrariesRecentlyAddedFetch', () {
    test(
      'should get data from GetRecentlyAdded use case',
      () async {
        // arrange
        setUpSuccess(tRecentList);
        clearCache();
        // act
        bloc.add(LibrariesRecentlyAddedFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
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
            sectionId: tSectionId,
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
        bloc.add(LibrariesRecentlyAddedFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
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
      'should emit [LibrariesRecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully and list is 25 or more',
      () async {
        // arrange
        setUpSuccess(tRecentList27);
        clearCache();
        // assert later
        final expected = [
          LibrariesRecentlyAddedSuccess(
            list: tRecentList27WithImages,
            hasReachedMax: false,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesRecentlyAddedFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [LibrariesRecentlyAddedFailure] with a proper message when getting data fails',
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
          LibrariesRecentlyAddedFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesRecentlyAddedFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'when state is [LibrariesRecentlyAddedSuccess] should emit [LibrariesRecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess(tRecentList27);
        clearCache();
        bloc.emit(
          LibrariesRecentlyAddedSuccess(
            list: tRecentList27WithImages,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          LibrariesRecentlyAddedSuccess(
            list: tRecentList27WithImages + tRecentList27WithImages,
            hasReachedMax: false,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesRecentlyAddedFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'when state is [LibrariesRecentlyAddedSuccess] should emit [LibrariesRecentlyAddedSuccess] with hasReachedMax as true when data is fetched successfully and less then 25',
      () async {
        // arrange
        setUpSuccess(tRecentList);
        clearCache();
        bloc.emit(
          LibrariesRecentlyAddedSuccess(
            list: tRecentListWithImages,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          LibrariesRecentlyAddedSuccess(
            list: tRecentListWithImages + tRecentListWithImages,
            hasReachedMax: true,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesRecentlyAddedFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });
}
