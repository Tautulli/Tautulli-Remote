import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_media_info.dart';
import 'package:tautulli_remote/features/libraries/presentation/bloc/library_media_bloc.dart';

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

  final tLibraryMediaInfoJson = json.decode(fixture('library_media_info.json'));
  tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
    tLibraryMediaList.add(LibraryMediaModel.fromJson(item));
  });

  void setUpSuccess() {
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
        length: anyNamed('length'),
      ),
    ).thenAnswer((_) async => Right(tLibraryMediaList));
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
        setUpSuccess();
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
        setUpSuccess();
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
      'should emit [LibraryMediaSuccess] data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          LibraryMediaInProgress(),
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaList,
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
      'should emit [LibrariesFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        clearCache();
        when(mockGetLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
          sectionId: anyNamed('sectionId'),
          length: anyNamed('length'),
        )).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          LibraryMediaInProgress(),
          LibraryMediaFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
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
