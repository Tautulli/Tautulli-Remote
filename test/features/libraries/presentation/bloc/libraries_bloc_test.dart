import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_libraries_table.dart';
import 'package:tautulli_remote/features/libraries/presentation/bloc/libraries_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibrariesTable extends Mock implements GetLibrariesTable {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibrariesBloc bloc;
  MockGetLibrariesTable mockGetLibrariesTable;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetLibrariesTable = MockGetLibrariesTable();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    bloc = LibrariesBloc(
      getLibrariesTable: mockGetLibrariesTable,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tOrderColumn = 'section_name';
  final tOrderDir = 'asc';
  String imageUrl =
      'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';

  final List<Library> tLibrariesList = [];
  final List<Library> tLibrariesListWithImages = [];

  final librariesJson = json.decode(fixture('libraries.json'));
  librariesJson['response']['data']['data'].forEach((item) {
    tLibrariesList.add(LibraryModel.fromJson(item));
  });

  for (Library item in tLibrariesList) {
    if (item.libraryThumb.contains('http')) {
      tLibrariesListWithImages.add(
        item.copyWith(backgroundUrl: imageUrl, iconUrl: imageUrl),
      );
    } else {
      tLibrariesListWithImages.add(
        item.copyWith(backgroundUrl: imageUrl),
      );
    }
  }

  void setUpSuccess() {
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
    when(
      mockGetLibrariesTable(
        tautulliId: tTautulliId,
        grouping: anyNamed('grouping'),
        length: anyNamed('length'),
        orderColumn: anyNamed('orderColumn'),
        orderDir: anyNamed('orderDir'),
        search: anyNamed('search'),
        start: anyNamed('start'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
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
      'should get data from GetLibrariesTable use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(
          LibrariesFetch(
            tautulliId: tTautulliId,
            orderColumn: tOrderColumn,
            orderDir: tOrderDir,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetLibrariesTable(
            tautulliId: tTautulliId,
            grouping: anyNamed('grouping'),
            length: anyNamed('length'),
            orderColumn: anyNamed('orderColumn'),
            orderDir: anyNamed('orderDir'),
            search: anyNamed('search'),
            start: anyNamed('start'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(mockGetLibrariesTable(
          tautulliId: tTautulliId,
          grouping: anyNamed('grouping'),
          length: anyNamed('length'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          search: anyNamed('search'),
          start: anyNamed('start'),
          settingsBloc: anyNamed('settingsBloc'),
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
          LibrariesFetch(
            tautulliId: tTautulliId,
            orderColumn: tOrderColumn,
            orderDir: tOrderDir,
            settingsBloc: settingsBloc,
          ),
        );
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
            tautulliId: tTautulliId,
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );

    test(
      'should emit [LibrariesSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          LibrariesSuccess(
            librariesList: tLibrariesListWithImages,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesFetch(
          tautulliId: tTautulliId,
          orderColumn: tOrderColumn,
          orderDir: tOrderDir,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [LibrariesFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        clearCache();
        when(
          mockGetLibrariesTable(
            tautulliId: tTautulliId,
            grouping: anyNamed('grouping'),
            length: anyNamed('length'),
            orderColumn: anyNamed('orderColumn'),
            orderDir: anyNamed('orderDir'),
            search: anyNamed('search'),
            start: anyNamed('start'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          LibrariesFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesFetch(
          tautulliId: tTautulliId,
          orderColumn: tOrderColumn,
          orderDir: tOrderDir,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  group('LibrariesFilter', () {
    test(
      'should emit [LibrariesInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          LibrariesInitial(),
          LibrariesSuccess(
            librariesList: tLibrariesListWithImages,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibrariesFilter(
          tautulliId: tTautulliId,
          orderColumn: tOrderColumn,
          orderDir: tOrderDir,
        ));
      },
    );
  });
}
