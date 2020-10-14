import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api.dart';
import 'package:tautulli_remote/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote/features/activity/data/models/activity_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettings extends Mock implements Settings {}

class MockTautulliApi extends Mock implements TautulliApi {}

class MockLogging extends Mock implements Logging {}

void main() {
  ActivityDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;
  MockLogging mockLogging;
  MockSettings mockSettings;

  setUp(() {
    mockSettings = MockSettings();
    mockTautulliApi = MockTautulliApi();
    mockLogging = MockLogging();
    dataSource = ActivityDataSourceImpl(
      settings: mockSettings,
      tautulliApi: mockTautulliApi,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'abc';

  final tActivityJson = json.decode(fixture('activity.json'));
  
  List<ActivityItem> tActivityList = [];
  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        ActivityItemModel.fromJson(session),
      );
    },
  );

  void setUpSuccess() {
    when(mockTautulliApi.getActivity(any))
        .thenAnswer((_) async => json.decode(fixture('activity.json')));
  }

  group('getActivity', () {
    test(
      'should call [getActivity] from TautulliApi',
      () async {
        // arrange
        setUpSuccess();
        //act
        await dataSource.getActivity(tautulliId: tTautulliId);
        //assert
        verify(mockTautulliApi.getActivity(tTautulliId));
      },
    );

    test(
      'should return list of ActivityItemModel',
      () async {
        // arrange
        setUpSuccess();
        //act
        final result = await dataSource.getActivity(tautulliId: tTautulliId);
        //assert
        expect(result, equals(tActivityList));
      },
    );
  });
}
