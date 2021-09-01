// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/history/data/models/history_model.dart';
import 'package:tautulli_remote/features/history/domain/entities/history.dart';
import 'package:tautulli_remote/features/history/domain/usecases/get_history.dart';
import 'package:tautulli_remote/features/history/presentation/bloc/history_libraries_bloc.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetHistory extends Mock implements GetHistory {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  HistoryLibrariesBloc bloc;
  MockGetHistory mockGetHistory;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetHistory = MockGetHistory();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();

    bloc = HistoryLibrariesBloc(
      getHistory: mockGetHistory,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'jkl';
  const tSectionId = 1;
  String imageUrl =
      'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';

  final List<History> tHistoryList = [];
  final List<History> tHistoryListWithImages = [];
  final List<History> tHistoryList25 = [];
  final List<History> tHistoryList25WithImages = [];

  final historyJson = json.decode(fixture('history.json'));

  historyJson['response']['data']['data'].forEach((item) {
    tHistoryList.add(HistoryModel.fromJson(item));
  });

  for (History item in tHistoryList) {
    tHistoryListWithImages.add(item.copyWith(posterUrl: imageUrl));
  }

  for (int i = 0; i < 25; i++) {
    historyJson['response']['data']['data'].forEach((item) {
      tHistoryList25.add(HistoryModel.fromJson(item));
    });
  }

  for (History item in tHistoryList25) {
    tHistoryList25WithImages.add(item.copyWith(posterUrl: imageUrl));
  }

  void setUpSuccess(List historyList) {
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
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(historyList));
  }

  test(
    'initialState should be HistoryLibrariesInitial',
    () async {
      // assert
      expect(bloc.state, HistoryLibrariesInitial());
    },
  );

  group('HistoryLibrariesFetch', () {
    test(
      'should get data from GetHistory use case',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        // act
        bloc.add(
          HistoryLibrariesFetch(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
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
            settingsBloc: anyNamed('settingsBloc'),
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
          settingsBloc: anyNamed('settingsBloc'),
        ));
      },
    );

    test(
      'should emit [HistoryLibrariesSuccess] with hasReachedMax as false when data is fetched successfully and list is 25 or more',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        // assert later
        final expected = [
          HistoryLibrariesInProgress(),
          HistoryLibrariesSuccess(
            list: tHistoryList25WithImages,
            hasReachedMax: false,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(HistoryLibrariesFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [HistoryLibrariesFailure] with a proper message when getting data fails',
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
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          HistoryLibrariesInProgress(),
          HistoryLibrariesFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(HistoryLibrariesFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'when state is [HistoryLibrariesSuccess] should emit [HistoryLibrariesSuccess] with hasReachedMax as false when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess(tHistoryList25);
        clearCache();
        bloc.emit(
          HistoryLibrariesSuccess(
            list: tHistoryList25WithImages,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          HistoryLibrariesSuccess(
            list: tHistoryList25WithImages + tHistoryList25WithImages,
            hasReachedMax: false,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(HistoryLibrariesFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'when state is [HistoryLibrariesSuccess] should emit [HistoryLibrariesSuccess] with hasReachedMax as true when data is fetched successfully and less then 25',
      () async {
        // arrange
        setUpSuccess(tHistoryList);
        clearCache();
        bloc.emit(
          HistoryLibrariesSuccess(
            list: tHistoryListWithImages,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          HistoryLibrariesSuccess(
            list: tHistoryListWithImages + tHistoryListWithImages,
            hasReachedMax: true,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(HistoryLibrariesFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });
}
