// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/error/exception.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/announcements/data/datasources/announcements_data_source.dart';
import 'package:tautulli_remote/features/announcements/data/models/announcement_model.dart';
import 'package:tautulli_remote/features/announcements/data/repositories/announcements_repository_impl.dart';
import 'package:tautulli_remote/features/announcements/domain/entities/announcement.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockAnnouncementsDataSource extends Mock
    implements AnnouncementsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  AnnouncementsRepositoryImpl repository;
  MockAnnouncementsDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    dataSource = MockAnnouncementsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AnnouncementsRepositoryImpl(
      dataSource: dataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final List tAnnouncementsJson = json.decode(fixture('announcements.json'));

  List<Announcement> tAnnouncementList = [];
  tAnnouncementsJson.forEach(
    (announcement) {
      tAnnouncementList.add(
        AnnouncementModel.fromJson(announcement),
      );
    },
  );

  group('getAnnouncements', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        await repository.getAnnouncements();
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getAnnouncements()',
        () async {
          // act
          await repository.getAnnouncements();
          // assert
          verify(dataSource.getAnnouncements());
        },
      );

      test(
        'should return list of Announcement when call is successful',
        () async {
          // arrange
          when(dataSource.getAnnouncements())
              .thenAnswer((_) async => tAnnouncementList);
          //act
          final result = await repository.getAnnouncements();
          //assert
          expect(result, equals(Right(tAnnouncementList)));
        },
      );

      test(
        'should return proper Failure using FailureMapperHelper if a known exception is thrown',
        () async {
          // arrange
          final exception = JsonDecodeException();
          when(dataSource.getAnnouncements()).thenThrow(exception);
          // act
          final result = await repository.getAnnouncements();
          // assert
          expect(result, equals(Left(JsonDecodeFailure())));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no internet',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          //act
          final result = await repository.getAnnouncements();
          //assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
