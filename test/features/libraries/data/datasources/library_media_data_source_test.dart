// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/libraries/data/datasources/library_media_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraryMediaInfo extends Mock
    implements tautulli_api.GetLibraryMediaInfo {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibraryMediaDataSourceImpl dataSource;
  MockGetLibraryMediaInfo mockApiGetLibraryMediaInfo;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetLibraryMediaInfo = MockGetLibraryMediaInfo();
    dataSource = LibraryMediaDataSourceImpl(
      apiGetLibraryMediaInfo: mockApiGetLibraryMediaInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const int tRatingKey = 53052;

  final tLibraryMediaInfoJson = json.decode(fixture('library_media_info.json'));

  final List<LibraryMedia> tLibraryMediaList = [];
  tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
    tLibraryMediaList.add(LibraryMediaModel.fromJson(item));
  });

  group('getLibraryMediaInfo', () {
    test(
      'should call [getLibraryMediaInfo] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetLibraryMediaInfo(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            refresh: true,
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tLibraryMediaInfoJson);
        // act
        await dataSource.getLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          refresh: true,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            refresh: true,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of LibraryMedia',
      () async {
        // arrange
        when(
          mockApiGetLibraryMediaInfo(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            refresh: true,
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tLibraryMediaInfoJson);
        // act
        final result = await dataSource.getLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          refresh: true,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tLibraryMediaList));
      },
    );
  });
}
