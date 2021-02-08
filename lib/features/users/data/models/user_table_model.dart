import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/user_table.dart';

class UserTableModel extends UserTable {
  UserTableModel({
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

  factory UserTableModel.fromJson(Map<String, dynamic> json) {
    return UserTableModel(
      duration: ValueHelper.cast(
        value: json['duration'],
        type: CastType.int,
      ),
      friendlyName: ValueHelper.cast(
        value: json['friendly_name'],
        type: CastType.string,
      ),
      isActive: ValueHelper.cast(
        value: json['is_active'],
        type: CastType.int,
      ),
      ipAddress: ValueHelper.cast(
        value: json['ip_address'],
        type: CastType.string,
      ),
      lastPlayed: ValueHelper.cast(
        value: json['last_played'],
        type: CastType.string,
      ),
      lastSeen: ValueHelper.cast(
        value: json['last_seen'],
        type: CastType.int,
      ),
      mediaType: ValueHelper.cast(
        value: json['media_type'],
        type: CastType.string,
      ),
      plays: ValueHelper.cast(
        value: json['plays'],
        type: CastType.int,
      ),
      ratingKey: ValueHelper.cast(
        value: json['rating_key'],
        type: CastType.int,
      ),
      userId: ValueHelper.cast(
        value: json['user_id'],
        type: CastType.int,
      ),
      userThumb: ValueHelper.cast(
        value: json['user_thumb'],
        type: CastType.string,
        nullEmptyString: false,
      ),
    );
  }
}
