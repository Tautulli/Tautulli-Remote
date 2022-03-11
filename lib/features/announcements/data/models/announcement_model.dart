import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcement_model.g.dart';

enum DevicePlatform {
  all,
  android,
  ios,
}

@JsonSerializable()
class AnnouncementModel extends Equatable {
  final String? actionUrl;
  final String body;
  final String date;
  final int id;
  @JsonKey(fromJson: castToPlatform)
  final DevicePlatform platform;
  final String title;

  const AnnouncementModel({
    required this.actionUrl,
    required this.body,
    required this.date,
    required this.id,
    required this.platform,
    required this.title,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementModelToJson(this);

  static DevicePlatform castToPlatform(String? platform) {
    if (platform == 'android') return DevicePlatform.android;
    if (platform == 'ios') return DevicePlatform.ios;

    return DevicePlatform.all;
  }

  @override
  List<Object> get props => [id];
}
