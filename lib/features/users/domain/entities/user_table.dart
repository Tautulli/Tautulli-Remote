// @dart=2.9

import 'package:equatable/equatable.dart';

class UserTable extends Equatable {
  final int duration;
  final String friendlyName;
  final int isActive;
  final String ipAddress;
  final String lastPlayed;
  final int lastSeen;
  final String mediaType;
  final int plays;
  final int ratingKey;
  final int userId;
  final String userThumb;

  UserTable({
    this.duration,
    this.friendlyName,
    this.isActive,
    this.ipAddress,
    this.lastPlayed,
    this.lastSeen,
    this.mediaType,
    this.plays,
    this.ratingKey,
    this.userId,
    this.userThumb,
  });

  @override
  List<Object> get props => [
        duration,
        friendlyName,
        isActive,
        ipAddress,
        lastPlayed,
        lastSeen,
        mediaType,
        plays,
        ratingKey,
        userId,
        userThumb,
      ];

  @override
  bool get stringify => true;
}
