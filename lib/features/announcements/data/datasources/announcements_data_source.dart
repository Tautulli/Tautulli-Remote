// @dart=2.9

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../domain/entities/announcement.dart';
import '../models/announcement_model.dart';

abstract class AnnouncementsDataSource {
  Future<List<Announcement>> getAnnouncements();
}

class AnnouncementsDataSourceImpl implements AnnouncementsDataSource {
  final http.Client client;

  AnnouncementsDataSourceImpl({@required this.client});

  @override
  Future<List<Announcement>> getAnnouncements() async {
    final response = await client.get(
      Uri.parse('https://tautulli.com/news/tautulli-remote-announcements.json'),
      headers: {'Content-Type': 'application/json'},
    );

    List responseJson;

    try {
      responseJson = json.decode(response.body);
    } catch (_) {
      throw JsonDecodeException();
    }

    List<Announcement> announcementList = [];
    for (Map<String, dynamic> announcement in responseJson) {
      announcementList.add(AnnouncementModel.fromJson(announcement));
    }

    return announcementList;
  }
}
