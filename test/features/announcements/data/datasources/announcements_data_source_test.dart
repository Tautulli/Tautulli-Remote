import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli_remote/features/announcements/data/datasources/announcements_data_source.dart';
import 'package:tautulli_remote/features/announcements/data/models/announcement_model.dart';
import 'package:tautulli_remote/features/announcements/domain/entities/announcement.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient mockClient;
  AnnouncementsDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = AnnouncementsDataSourceImpl(
      client: mockClient,
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

  void setUpSuccess() {
    when(
      mockClient.get(
        Uri.parse(
          'https://tautulli.com/news/tautulli-remote-announcements.json',
        ),
        headers: {'Content-Type': 'application/json'},
      ),
    ).thenAnswer(
      (_) async => http.Response(
        fixture('announcements.json'),
        200,
      ),
    );
  }

  group('getAnnouncements', () {
    test(
      'should fetch announcements',
      () async {
        // arrange
        setUpSuccess();
        //act
        await dataSource.getAnnouncements();
        //assert
        verify(
          mockClient.get(
            Uri.parse(
              'https://tautulli.com/news/tautulli-remote-announcements.json',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return list of AnnouncementModel',
      () async {
        // arrange
        setUpSuccess();
        //act
        final result = await dataSource.getAnnouncements();
        //assert
        expect(result, equals(tAnnouncementList));
      },
    );
  });
}
