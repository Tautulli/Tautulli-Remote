import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/features/activity/data/models/activity_model.dart';
import 'package:tautulli_remote/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote/features/activity/domain/usecases/get_activity.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetActivity extends Mock implements GetActivity {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  ActivityBloc bloc;
  MockSettings mockSettings;
  MockGetActivity mockGetActivity;
  MockGetImageUrl mockGetImageUrl;
  MockLogging mockLogging;

  setUp(() {
    mockGetActivity = MockGetActivity();
    mockSettings = MockSettings();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();

    bloc = ActivityBloc(
      activity: mockGetActivity,
      imageUrl: mockGetImageUrl,
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';

  final tActivityJson = json.decode(fixture('activity.json'));

  List<ActivityItem> tActivityList = [];
  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        ActivityItemModel.fromJson(session),
      );
    },
  );

  final serverModel = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionPath: null,
    secondaryConnectionAddress: 'https://plexpy.com',
    secondaryConnectionProtocol: 'https',
    secondaryConnectionDomain: 'plexpy.com',
    secondaryConnectionPath: null,
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
    primaryActive: true,
    plexPass: true,
  );

  List<ServerModel> tServerList = [serverModel];

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
    when(mockGetActivity(tautulliId: tTautulliId))
        .thenAnswer((_) async => Right(tActivityList));
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
  }

  test(
    'initialState should be ActivityEmpty',
    () async {
      // assert
      expect(bloc.state, ActivityInitial(activityMap: {}));
    },
  );

  group('ActivityLoadAndRefresh', () {
    test(
      'should call Settings to get list of servers',
      () async {
        //arrange
        setUpSuccess();
        // act
        bloc.add(ActivityLoadAndRefresh());
        await untilCalled(mockSettings.getAllServers());
        // assert
        verify(mockSettings.getAllServers());
      },
    );

    test(
      'should get data from the GetActivity use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(ActivityLoadAndRefresh());
        await untilCalled(mockGetActivity(tautulliId: tTautulliId));
        // assert
        verify(mockGetActivity(tautulliId: tTautulliId));
      },
    );

    test(
      'should get data from the GetImageUrl use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(ActivityLoadAndRefresh());
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
            tautulliId: anyNamed('tautulliId'),
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
          ),
        );
      },
    );

    //   //! DateTime.now() is not going to exactly line up in the expected and actual function causing this test to fail
    //   // test(
    //   //   'should emit [ActivityLoadAndRefreshSuccess] when data is gotten successfully',
    //   //   () async {
    //   //     // arrange
    //   //     setUpSuccess();
    //   //     // assert later
    //   //     final expected = [
    //   //       ActivityLoadAndRefreshInProgress(),
    //   //       ActivityLoadAndRefreshSuccess(
    //   //         activityMap: tActivityMap,
    //   //         loadedAt: DateTime.now(),
    //   //         // DateTime.parse("1969-07-20 20:18:04Z")
    //   //       ),
    //   //     ];
    //   //     expectLater(bloc, emitsInOrder(expected));
    //   //     // act
    //   //     bloc.add(ActivityLoadAndRefresh());
    //   //   },
    //   // );
  });
}
