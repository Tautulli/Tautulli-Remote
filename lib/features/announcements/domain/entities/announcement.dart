import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Announcement extends Equatable {
  final int id;
  final String date;
  final String title;
  final String body;
  final String actionUrl;

  Announcement({
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.body,
    this.actionUrl,
  });

  @override
  List<Object> get props => [id, date, title, body, actionUrl];

  @override
  bool get stringify => true;
}
