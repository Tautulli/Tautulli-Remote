import 'package:equatable/equatable.dart';

class History extends Equatable {
  final int date;
  final int duration;
  final String friendlyName;
  final String fullTitle;
  final int grandparentRatingKey;
  final String grandparentTitle;
  final int groupCount;
  final List<int> groupIds;
  final int id;
  final String ipAddress;
  final int live;
  final int mediaIndex;
  final String mediaType;
  final int parentMediaIndex;
  final int parentRatingKey;
  final String parentTitle;
  final int pausedCounter;
  final int percentComplete;
  final String platform;
  final String player;
  final String product;
  final int ratingKey;
  final int sessionKey;
  final int started;
  final String state;
  final int stopped;
  final String title;
  final String thumb;
  final String transcodeDecision;
  final String user;
  final int userId;
  final num watchedStatus;
  final int year;
  String posterUrl;

  History({
    this.date,
    this.duration,
    this.friendlyName,
    this.fullTitle,
    this.grandparentRatingKey,
    this.grandparentTitle,
    this.groupCount,
    this.groupIds,
    this.id,
    this.ipAddress,
    this.live,
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentTitle,
    this.pausedCounter,
    this.percentComplete,
    this.platform,
    this.player,
    this.product,
    this.ratingKey,
    this.sessionKey,
    this.started,
    this.state,
    this.stopped,
    this.title,
    this.thumb,
    this.transcodeDecision,
    this.user,
    this.userId,
    this.watchedStatus,
    this.year,
    this.posterUrl,
  });

  @override
  List<Object> get props => [
        date,
        duration,
        friendlyName,
        fullTitle,
        grandparentRatingKey,
        grandparentTitle,
        groupCount,
        groupIds,
        id,
        ipAddress,
        live,
        mediaIndex,
        mediaType,
        parentMediaIndex,
        parentRatingKey,
        parentTitle,
        pausedCounter,
        percentComplete,
        platform,
        player,
        product,
        ratingKey,
        sessionKey,
        started,
        state,
        stopped,
        title,
        thumb,
        transcodeDecision,
        user,
        userId,
        watchedStatus,
        year,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
