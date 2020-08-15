import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    int duration,
    String friendlyName,
    int isActive,
    String ipAddress,
    String lastPlayed,
    int lastSeen,
    String mediaType,
    int plays,
    int ratingKey,
    int userId,
    String userThumb,
  }) : super(
          duration: duration,
          friendlyName: friendlyName,
          isActive: isActive,
          ipAddress: ipAddress,
          lastPlayed: lastPlayed,
          lastSeen: lastSeen,
          mediaType: mediaType,
          plays: plays,
          ratingKey: ratingKey,
          userId: userId,
          userThumb: userThumb,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      duration: json['duration'],
      friendlyName: json['friendly_name'],
      isActive: json['is_active'],
      ipAddress: json['ip_address'],
      lastPlayed: json['last_played'],
      lastSeen: json['last_seen'],
      mediaType: json['media_type'],
      plays: json['plays'],
      ratingKey: json['rating_key'],
      userId: json['user_id'],
      userThumb: json['user_thumb'],
    );
  }
}
