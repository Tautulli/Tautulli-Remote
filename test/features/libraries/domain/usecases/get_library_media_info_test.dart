import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/libraries/domain/repositories/library_media_repository.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_media_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibraryMediaRepository extends Mock
    implements LibraryMediaRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetLibraryMediaInfo usecase;
  MockLibraryMediaRepository mockLibraryMediaRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockLibraryMediaRepository = MockLibraryMediaRepository();
    usecase = GetLibraryMediaInfo(
      repository: mockLibraryMediaRepository,
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

  test(
    'should get list of LibraryMedia from repository',
    () async {
      // arrange
      when(
        mockLibraryMediaRepository.getLibraryMediaInfo(
          tautulliId: anyNamed('tautulliId'),
          ratingKey: anyNamed('ratingKey'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          refresh: anyNamed('refresh'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tLibraryMediaList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ratingKey: tRatingKey,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tLibraryMediaList)));
    },
  );
}
