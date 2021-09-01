// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/recent/data/datasources/recently_added_data_source.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetRecentlyAdded extends Mock
    implements tautulli_api.GetRecentlyAdded {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  RecentlyAddedDataSourceImpl dataSource;
  MockGetRecentlyAdded mockApiGetRecentlyAdded;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetRecentlyAdded = MockGetRecentlyAdded();
    dataSource = RecentlyAddedDataSourceImpl(
      apiGetRecentlyAdded: mockApiGetRecentlyAdded,
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
  const int tCount = 10;

  final List<RecentItem> tRecentList = [];

  final recentJson = json.decode(fixture('recent.json'));

  recentJson['response']['data']['recently_added'].forEach((item) {
    tRecentList.add(RecentItemModel.fromJson(item));
  });

  group('getRecentlyAdded', () {
    test(
      'should call [getRecentActivty] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => recentJson);
        // act
        await dataSource.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should return list of RecentItemModel',
      () async {
        // arrange
        when(
          mockApiGetRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => recentJson);
        // act
        final result = await dataSource.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tRecentList));
      },
    );
  });
}
