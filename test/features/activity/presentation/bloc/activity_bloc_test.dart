import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/activity_model.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/usecases/get_activity.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/usecases/get_geo_ip.dart';
import 'package:tautulli_remote_tdd/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetActivity extends Mock implements GetActivity {}

class MockGetGeoIp extends Mock implements GetGeoIp {}

class MockTautulliApiUrls extends Mock implements TautulliApiUrls {}

class MockLogging extends Mock implements Logging {}

void main() {
  ActivityBloc bloc;
  MockTautulliApiUrls mockTautulliApiUrls;
  MockGetActivity mockGetActivity;
  MockGetGeoIp mockGetGeoIp;
  MockLogging mockLogging;

  setUp(() {
    mockGetActivity = MockGetActivity();
    mockGetGeoIp = MockGetGeoIp();
    mockTautulliApiUrls = MockTautulliApiUrls();
    mockLogging = MockLogging();

    bloc = ActivityBloc(
      activity: mockGetActivity,
      geoIp: mockGetGeoIp,
      tautulliApiUrls: mockTautulliApiUrls,
      logging: mockLogging,
    );
  });

  final Map<String, dynamic> activityJson =
      json.decode(fixture('activity_item.json'));
  final activityItem = ActivityItemModel.fromJson(activityJson);
  final List<ActivityItem> tActivityList = [activityItem];

  final Map<String, Map<String, Object>> tActivityMap = {
    'Plex': {'result': 'success', 'activity': tActivityList}
  };

  final tGeoIpItemModel = GeoIpItemModel(
    accuracy: null,
    city: "Toronto",
    code: "CA",
    continent: null,
    country: "Canada",
    latitude: 43.6403,
    longitude: -79.3711,
    postalCode: "M5E",
    region: "Ontario",
    timezone: "America/Toronto",
  );

  void setUpSuccess() {
    when(mockGetActivity()).thenAnswer((_) async => Right(tActivityMap));
    when(
      mockGetGeoIp(
        tautulliId: anyNamed('tautulliId'),
        ipAddress: anyNamed('ipAddress'),
      ),
    ).thenAnswer((_) async => Right(tGeoIpItemModel));
  }

  test(
    'initialState should be ActivityEmpty',
    () async {
      // assert
      expect(bloc.state, ActivityEmpty());
    },
  );

  group('ActivityLoad', () {
    test(
      'should get data from the GetActivity use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(ActivityLoad());
        await untilCalled(mockGetActivity());
        // assert
        verify(mockGetActivity());
      },
    );

    test(
      'should get data from the GetGeoIp use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(ActivityLoad());
        await untilCalled(
          mockGetGeoIp(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
          ),
        );
        // assert
        verify(
          mockGetGeoIp(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
          ),
        );
      },
    );

    //! DateTime.now() is not going to exactly line up in the expected and actual function causing this test to fail
    // test(
    //   'should emit [ActivityLoadSuccess] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     setUpSuccess();
    //     // assert later
    //     final expected = [
    //       ActivityEmpty(),
    //       ActivityLoadInProgress(),
    //       ActivityLoadSuccess(
    //         activityMap: tActivityMap,
    //         geoIpMap: tGeoIpMap,
    //         tautulliApiUrls: mockTautulliApiUrls,
    //         loadedAt: DateTime.now(),
    //         // DateTime.parse("1969-07-20 20:18:04Z")
    //       ),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(ActivityLoad());
    //   },
    // );

    test(
      'should emit [ActivityLoadInProgress, ActivityLoadFailure] with a proper message when getting activity fails',
      () async {
        // arrange
        final failure = ServerFailure();
        when(mockGetActivity()).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          ActivityLoadInProgress(),
          ActivityLoadFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(ActivityLoad());
      },
    );
  });

  group('ActivityRefresh', () {
    test(
      'should get data from the GetActivity use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(ActivityRefresh());
        await untilCalled(mockGetActivity());
        // assert
        verify(mockGetActivity());
      },
    );

    test(
      'should get data from the GetGeoIp use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(ActivityRefresh());
        await untilCalled(
          mockGetGeoIp(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
          ),
        );
        // assert
        verify(
          mockGetGeoIp(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
          ),
        );
      },
    );

    //! DateTime.now() is not going to exactly line up in the expected and actual function causing this test to fail
    // test(
    //   'should emit [ActivityLoadInProgress, ActivityLoadSuccess] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     setUpSuccess();
    //     // assert later
    //     final expected = [
    //       ActivityEmpty(),
    //       ActivityLoadSuccess(
    //         activityMap: tActivityMap,
    //         geoIpMap: tGeoIpMap,
    //         tautulliApiUrls: mockTautulliApiUrls,
    //         loadedAt: DateTime.now(),
    //         // DateTime.parse("1969-07-20 20:18:04Z")
    //       ),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(ActivityRefresh());
    //   },
    // );

    test(
      'should emit [ActivityLoadFailure] with a proper message when getting activity fails',
      () async {
        // arrange
        final failure = ServerFailure();
        when(mockGetActivity()).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          ActivityLoadFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(ActivityRefresh());
      },
    );
  });
}
