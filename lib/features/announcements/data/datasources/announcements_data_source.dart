import 'package:dio/dio.dart';

import '../models/announcement_model.dart';

abstract class AnnouncementsDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
}

class AnnouncementsDataSourceImpl implements AnnouncementsDataSource {
  final Dio dio;

  AnnouncementsDataSourceImpl({required this.dio});

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await dio.get(
      'https://tautulli.com/news/tautulli-remote-announcements.json',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    List<AnnouncementModel> announcementList = [];

    for (Map<String, dynamic> announcement in response.data) {
      announcementList.add(AnnouncementModel.fromJson(announcement));
    }

    return announcementList;
  }
}
