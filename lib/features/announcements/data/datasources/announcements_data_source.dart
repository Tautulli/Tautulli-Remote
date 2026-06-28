import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/announcement_model.dart';

abstract class AnnouncementsDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
}

class AnnouncementsDataSourceImpl implements AnnouncementsDataSource {
  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await http.get(
      Uri.parse('https://tautulli.com/news/tautulli-remote-announcements.json'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .whereType<Map<String, dynamic>>()
        .map(AnnouncementModel.fromJson)
        .toList();
  }
}
