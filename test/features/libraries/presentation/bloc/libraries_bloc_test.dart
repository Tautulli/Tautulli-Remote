import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote_tdd/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote_tdd/features/libraries/domain/entities/library.dart';
import 'package:tautulli_remote_tdd/features/libraries/domain/usercases/get_libraries.dart';
import 'package:tautulli_remote_tdd/features/libraries/presentation/bloc/libraries_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraries extends Mock implements GetLibraries {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

void main() {
  LibrariesBloc bloc;
  MockGetLibraries mockGetLibraries;
  MockGetImageUrl mockGetImageUrl;

  setUp(() {
    mockGetLibraries = MockGetLibraries();
    mockGetImageUrl = MockGetImageUrl();
    bloc = LibrariesBloc(
      getLibraries: mockGetLibraries,
      getImageUrl: mockGetImageUrl,
    );
  });

  final tTautulliId = 'jkl';

  final List<Library> tLibrariesList = [];

  final userJson = json.decode(fixture('libraries.json'));
  userJson['response']['data'].forEach((item) {
    tLibrariesList.add(LibraryModel.fromJson(item));
  });

  Map<String, List<Library>> tLibrariesMap = {
    'movie': [],
    'show': [],
    'artist': [],
    'photo': [],
  };

  for (int i = 0; i < tLibrariesList.length; i++) {
    tLibrariesMap[tLibrariesList[i].sectionType].add(tLibrariesList[i]);
  }

  for (String key in tLibrariesMap.keys) {
    tLibrariesMap[key].sort((a, b) {
      var result = b.count.compareTo(a.count);
      if (result != 0) {
        return result;
      }
      if (b.parentCount != null) {
        result = b.parentCount.compareTo(a.parentCount);
        if (result != 0) {
          return result;
        }
      }
      if (b.childCount != null) {
        result = b.childCount.compareTo(a.childCount);
        if (result != 0) {
          return result;
        }
      }
      return a.sectionName.compareTo(b.sectionName);
    });
  }

  Map<String, String> tImageMap = {
    'movie':
        'https://tautulli.wreave.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true',
    'show':
        'https://tautulli.wreave.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true',
  };

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.wreave.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
    when(
      mockGetLibraries(tautulliId: tTautulliId),
    ).thenAnswer((_) async => Right(tLibrariesList));
  }

  test(
    'initialState should be LibrariesInitial',
    () async {
      // assert
      expect(bloc.state, LibrariesInitial());
    },
  );

  group('LibrariesFetch', () {
    test(
      'should get data from GetLibraries use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          LibrariesFetch(tautulliId: tTautulliId),
        );
        await untilCalled(
          mockGetLibraries(tautulliId: tTautulliId),
        );
        // assert
        verify(mockGetLibraries(tautulliId: tTautulliId));
      },
    );

    test(
      'should get data from the ImageUrl use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          LibrariesFetch(tautulliId: tTautulliId),
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
      'should emit [LibrariesSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          LibrariesSuccess(
            librariesMap: tLibrariesMap,
            imageMap: tImageMap,
            librariesCount: tLibrariesList.length,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(LibrariesFetch(tautulliId: tTautulliId));
      },
    );

    test(
      'should emit [LibrariesFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        when(
          mockGetLibraries(tautulliId: tTautulliId),
        ).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          LibrariesFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(LibrariesFetch(tautulliId: tTautulliId));
      },
    );
  });

  group('LibrariesFilter', () {
    test(
      'should emit [LibrariesInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          LibrariesInitial(),
          LibrariesSuccess(
            librariesMap: tLibrariesMap,
            imageMap: tImageMap,
            librariesCount: tLibrariesList.length,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(LibrariesFilter(tautulliId: tTautulliId));
      },
    );
  });
}
