// @dart=2.9

import 'package:equatable/equatable.dart';

class Library extends Equatable {
  final int childCount;
  final int count;
  // final String contentRating;
  // final String doNotify;
  // final String doNotifiyCreated;
  final int duration;
  // final String guid;
  // final int historyRowId;
  final int isActive;
  // final String keepHistory;
  // final List labels;
  final int lastAccessed;
  // final String lastPlayed;
  final String libraryArt;
  final String libraryThumb;
  // final int live;
  // final int mediaIndex;
  // final String mediaType;
  // final String originallyAvailableAt;
  final int parentCount;
  // final int parentMediaIndex;
  // final String parentTitle;
  final int plays;
  // final int ratingKey;
  // final int rowId;
  final int sectionId;
  final String sectionName;
  final String sectionType;
  // final String serverId;
  // final String thumb;
  // final int year;
  final String iconUrl;
  final String backgroundUrl;

  Library({
    this.childCount,
    this.count,
    // this.contentRating,
    // this.doNotify,
    // this.doNotifiyCreated,
    this.duration,
    // this.guid,
    // this.historyRowId,
    this.isActive,
    // this.keepHistory,
    // this.labels,
    this.lastAccessed,
    // this.lastPlayed,
    this.libraryArt,
    this.libraryThumb,
    // this.live,
    // this.mediaIndex,
    // this.mediaType,
    // this.originallyAvailableAt,
    this.parentCount,
    // this.parentMediaIndex,
    // this.parentTitle,
    this.plays,
    // this.ratingKey,
    // this.rowId,
    this.sectionId,
    this.sectionName,
    this.sectionType,
    // this.serverId,
    // this.thumb,
    // this.year,
    this.iconUrl,
    this.backgroundUrl,
  });

  Library copyWith({
    String iconUrl,
    String backgroundUrl,
  }) {
    return Library(
      childCount: this.childCount,
      count: this.count,
      // contentRating: this.contentRating,
      // doNotify: this.doNotify,
      // doNotifiyCreated: this.doNotifiyCreated,
      duration: this.duration,
      // guid: this.guid,
      // historyRowId: this.historyRowId,
      isActive: this.isActive,
      // keepHistory: this.keepHistory,
      // labels: this.labels,
      lastAccessed: this.lastAccessed,
      // lastPlayed: this.lastPlayed,
      libraryArt: this.libraryArt,
      libraryThumb: this.libraryThumb,
      // live: this.live,
      // mediaIndex: this.mediaIndex,
      // mediaType: this.mediaType,
      // originallyAvailableAt: this.originallyAvailableAt,
      parentCount: this.parentCount,
      // parentMediaIndex: this.parentMediaIndex,
      // parentTitle: this.parentTitle,
      plays: this.plays,
      // ratingKey: this.ratingKey,
      // rowId: this.rowId,
      sectionId: this.sectionId,
      sectionName: this.sectionName,
      sectionType: this.sectionType,
      // serverId: this.serverId,
      // thumb: this.thumb,
      // year: this.year,
      iconUrl: iconUrl,
      backgroundUrl: backgroundUrl,
    );
  }

  @override
  List<Object> get props => [
        childCount,
        count,
        // contentRating,
        // doNotify,
        // doNotifiyCreated,
        duration,
        // guid,
        // historyRowId,
        isActive,
        // keepHistory,
        // labels,
        lastAccessed,
        // lastPlayed,
        libraryArt,
        libraryThumb,
        // live,
        // mediaIndex,
        // mediaType,
        // originallyAvailableAt,
        parentCount,
        // parentMediaIndex,
        // parentTitle,
        plays,
        // ratingKey,
        // rowId,
        sectionId,
        sectionName,
        sectionType,
        // serverId,
        // thumb,
        // year,
        iconUrl,
        backgroundUrl,
      ];

  @override
  bool get stringify => true;
}
