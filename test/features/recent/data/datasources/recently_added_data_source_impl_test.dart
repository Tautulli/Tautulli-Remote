import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/recent/data/datasources/recently_added_data_source.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetRecentlyAdded extends Mock
    implements tautulliApi.GetRecentlyAdded {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  RecentlyAddedDataSourceImpl dataSource;
  MockGetRecentlyAdded mockApiGetRecentlyAdded;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetRecentlyAdded = MockGetRecentlyAdded();
    dataSource = RecentlyAddedDataSourceImpl(
      apiGetRecentlyAdded: mockApiGetRecentlyAdded,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final int tCount = 10;

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
