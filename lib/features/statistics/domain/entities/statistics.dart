import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  // final String art;
  // final String contentRating;
  final int count;
  final String friendlyName;
  final String grandparentThumb;
  // final String guid;
  // final List labels;
  // final int lastPlay;
  final int lastWatch;
  // final int live;
  final String mediaType;
  final String platform;
  final String platformName;
  // final String player;
  final int ratingKey;
  final int rowId;
  final int sectionId;
  final int started;
  // final int stopped;
  final String statId;
  final String thumb;
  final String title;
  final int totalDuration;
  final int totalPlays;
  final String user;
  final int userId;
  final int usersWatched;
  final String userThumb;
  String posterUrl;

  Statistics({
    // this.art,
    // this.contentRating,
    this.count,
    this.friendlyName,
    this.grandparentThumb,
    // this.guid,
    // this.labels,
    // this.lastPlay,
    this.lastWatch,
    // this.live,
    this.mediaType,
    this.platform,
    this.platformName,
    // this.player,
    this.ratingKey,
    this.rowId,
    this.sectionId,
    this.started,
    // this.stopped,
    this.statId,
    this.thumb,
    this.title,
    this.totalDuration,
    this.totalPlays,
    this.user,
    this.userId,
    this.usersWatched,
    this.userThumb,
    this.posterUrl,
  });

  @override
  List<Object> get props => [
        // art,
        // contentRating,
        count,
        friendlyName,
        grandparentThumb,
        // guid,
        // labels,
        // lastPlay,
        lastWatch,
        // live,
        mediaType,
        platform,
        platformName,
        // player,
        ratingKey,
        rowId,
        sectionId,
        started,
        // stopped,
        statId,
        thumb,
        title,
        totalDuration,
        totalPlays,
        user,
        userId,
        usersWatched,
        userThumb,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
