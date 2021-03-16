import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  final String art;
  // final String contentRating;
  final int count;
  final String friendlyName;
  final String grandchildTitle;
  final int grandparentRatingKey;
  final String grandparentThumb;
  final String grandparentTitle;
  // final String guid;
  // final List labels;
  // final int lastPlay;
  final int lastWatch;
  // final int live;
  final int mediaIndex;
  final String mediaType;
  final int parentMediaIndex;
  final String platform;
  final String platformName;
  // final String player;
  final int ratingKey;
  final int rowId;
  final int sectionId;
  final String sectionName;
  final String sectionType;
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
  final int year;
  String posterUrl;

  Statistics({
    this.art,
    // this.contentRating,
    this.count,
    this.friendlyName,
    this.grandchildTitle,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    // this.guid,
    // this.labels,
    // this.lastPlay,
    this.lastWatch,
    // this.live,
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.platform,
    this.platformName,
    // this.player,
    this.ratingKey,
    this.rowId,
    this.sectionId,
    this.sectionName,
    this.sectionType,
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
    this.year,
    this.posterUrl,
  });

  @override
  List<Object> get props => [
        art,
        // contentRating,
        count,
        friendlyName,
        grandchildTitle,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        // guid,
        // labels,
        // lastPlay,
        lastWatch,
        // live,
        mediaIndex,
        mediaType,
        parentMediaIndex,
        platform,
        platformName,
        // player,
        ratingKey,
        rowId,
        sectionId,
        sectionName,
        sectionType,
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
        year,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
