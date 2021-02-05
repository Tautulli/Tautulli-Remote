import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/media/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_library_media_info.dart';
import 'package:tautulli_remote/features/media/presentation/bloc/library_media_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraryMediaInfo extends Mock implements GetLibraryMediaInfo {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

void main() {
  LibraryMediaBloc bloc;
  MockGetLibraryMediaInfo mockGetLibraryMediaInfo;
  MockGetImageUrl mockGetImageUrl;

  setUp(() {
    mockGetLibraryMediaInfo = MockGetLibraryMediaInfo();
    mockGetImageUrl = MockGetImageUrl();

    bloc = LibraryMediaBloc(
      getLibraryMediaInfo: mockGetLibraryMediaInfo,
      getImageUrl: mockGetImageUrl,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final List<LibraryMedia> tLibraryMediaList = [];
  final List<LibraryMedia> tLibraryMediaList25 = [];

  final tLibraryMediaInfoJson = json.decode(fixture('library_media_info.json'));
  tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
    tLibraryMediaList.add(LibraryMediaModel.fromJson(item));
  });

  for (int i = 0; i < 3; i++) {
    tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
      tLibraryMediaList25.add(LibraryMediaModel.fromJson(item));
    });
  }

  void setUpSuccess(List<LibraryMedia> libraryMediaList) {
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
      mockGetLibraryMediaInfo(
        tautulliId: tTautulliId,
        ratingKey: anyNamed('ratingKey'),
        sectionId: anyNamed('sectionId'),
        start: anyNamed('start'),
        length: anyNamed('length'),
      ),
    ).thenAnswer((_) async => Right(libraryMediaList));
  }

  test(
    'initialState should be LibraryMediaInitial',
    () async {
      // assert
      expect(bloc.state, LibraryMediaInitial());
    },
  );

  group('LibraryMediaFetched', () {
    test(
      'should get data from GetLibraryMedia use case',
      () async {
        // arrange
        setUpSuccess(tLibraryMediaList);
        clearCache();
        // act
        bloc.add(
          LibraryMediaFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
          ),
        );
        await untilCalled(
          mockGetLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
            sectionId: anyNamed('sectionId'),
            start: anyNamed('start'),
            length: anyNamed('length'),
          ),
        );
        // assert
        verify(mockGetLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
          sectionId: anyNamed('sectionId'),
          start: anyNamed('start'),
          length: anyNamed('length'),
        ));
      },
    );

    test(
      'should get data from the ImageUrl use case',
      () async {
        // arrange
        setUpSuccess(tLibraryMediaList);
        clearCache();
        // act
        bloc.add(
          LibraryMediaFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
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
      'should emit [LibraryMediaSuccess] with hasReachedMax as false when data is fetched successfully and list is 25 or more',
      () async {
        // arrange
        setUpSuccess(tLibraryMediaList25);
        clearCache();
        // assert later
        final expected = [
          LibraryMediaInProgress(),
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(LibraryMediaFetched(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );

    test(
      'when state is [LibraryMediaSuccess] should emit [LibraryMediaSuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess(tLibraryMediaList25);
        clearCache();
        bloc.emit(
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaList25,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaList25 + tLibraryMediaList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(LibraryMediaFetched(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );

    test(
      'when state is [LibraryMediaSuccess] should emit [LibraryMediaSuccess] with hasReachedMax as true when data is fetched successfully and less then 25',
      () async {
        // arrange
        setUpSuccess(tLibraryMediaList);
        clearCache();
        bloc.emit(
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaList,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaList + tLibraryMediaList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(LibraryMediaFetched(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
        ));
      },
    );
  });
}
