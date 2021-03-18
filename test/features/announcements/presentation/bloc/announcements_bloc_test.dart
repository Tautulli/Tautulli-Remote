import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/announcements/data/models/announcement_model.dart';
import 'package:tautulli_remote/features/announcements/domain/entities/announcement.dart';
import 'package:tautulli_remote/features/announcements/domain/usecases/get_announcements.dart';
import 'package:tautulli_remote/features/announcements/presentation/bloc/announcements_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetAnnouncements extends Mock implements GetAnnouncements {}

class MockLogging extends Mock implements Logging {}

void main() {
  AnnouncementsBloc bloc;
  MockGetAnnouncements mockGetAnnouncements;
  MockLogging mockLogging;

  setUp(() {
    mockGetAnnouncements = MockGetAnnouncements();
    mockLogging = MockLogging();
    bloc = AnnouncementsBloc(
      getAnnouncements: mockGetAnnouncements,
      logging: mockLogging,
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

  // void setUpSuccess() {
  //   when(mockGetAnnouncements())
  //       .thenAnswer((_) async => Right(tAnnouncementList));
  // }

  test(
    'initialState should be AnnouncementsInitial',
    () async {
      // assert
      expect(bloc.state, AnnouncementsInitial());
    },
  );

  //TODO: Unsure how to run a test when dependency injection is being used
  // group('AnnouncementsFetch', () {
  //   test(
  //     'should get data from GetAnnouncements use case',
  //     () async {
  //       // arrange
  //       setUpSuccess();
  //       // act
  //       bloc.add(
  //         AnnouncementsFetch(),
  //       );
  //       await untilCalled(mockGetAnnouncements());
  //       // assert
  //       verify(mockGetAnnouncements());
  //     },
  //   );

  //   test(
  //     'should emit [AnnouncementsSuccess] with unread as true when data is fetched successfully and list is longer than stored read count',
  //     () async {
  //       // arrange
  //       setUpSuccess();
  //       // assert later
  //       final expected = [
  //         AnnouncementsSuccess(
  //           announcementList: tAnnouncementList,
  //           unread: true,
  //         ),
  //       ];
  //       expectLater(bloc, emitsInOrder(expected));
  //       // act
  //       bloc.add(AnnouncementsFetch());
  //     },
  //   );
  // });
}
