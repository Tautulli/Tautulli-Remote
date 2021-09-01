// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/announcements/data/models/announcement_model.dart';
import 'package:tautulli_remote/features/announcements/domain/entities/announcement.dart';
import 'package:tautulli_remote/features/announcements/domain/repositories/announcements_repository.dart';
import 'package:tautulli_remote/features/announcements/domain/usecases/get_announcements.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockAnnouncementsRepository extends Mock
    implements AnnouncementsRepository {}

void main() {
  GetAnnouncements usecase;
  MockAnnouncementsRepository mockAnnouncementsRepository;

  setUp(() {
    mockAnnouncementsRepository = MockAnnouncementsRepository();
    usecase = GetAnnouncements(repository: mockAnnouncementsRepository);
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

  test(
    'should get Announcements from the web',
    () async {
      // arrange
      when(mockAnnouncementsRepository.getAnnouncements())
          .thenAnswer((_) async => Right(tAnnouncementList));
      //act
      final result = await usecase();
      //assert
      expect(result, Right(tAnnouncementList));
      verify(mockAnnouncementsRepository.getAnnouncements());
      verifyNoMoreInteractions(mockAnnouncementsRepository);
    },
  );
}
