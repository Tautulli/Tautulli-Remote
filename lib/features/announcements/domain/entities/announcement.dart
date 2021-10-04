// @dart=2.9

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Announcement extends Equatable {
  final int id;
  final String date;
  final String title;
  final String body;
  final String platform;
  final String actionUrl;

  Announcement({
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.body,
    @required this.platform,
    this.actionUrl,
  });

  @override
  List<Object> get props => [id, date, title, body, platform, actionUrl];

  @override
  bool get stringify => true;
}
