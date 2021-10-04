// @dart=2.9

import 'package:meta/meta.dart';

import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  AnnouncementModel({
    @required final int id,
    @required final String date,
    @required final String title,
    @required final String body,
    @required final String platform,
    final String actionUrl,
  }) : super(
          id: id,
          date: date,
          body: body,
          title: title,
          platform: platform,
          actionUrl: actionUrl,
        );

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      date: json['date'],
      actionUrl: json['actionUrl'],
      body: json['body'],
      title: json['title'],
      platform: json['platform'],
    );
  }
}
