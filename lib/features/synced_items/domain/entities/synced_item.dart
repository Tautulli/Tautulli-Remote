// @dart=2.9

import 'package:equatable/equatable.dart';

class SyncedItem extends Equatable {
  // final int audioBitrate;
  final String clientId;
  // final String contentType;
  final String deviceName;
  // final String failure;
  // final int itemDownloadedCount;
  // final int itemDownloadedPercentComplete;
  final int itemCompleteCount;
  // final int itemCount;
  final String mediaType;
  final bool multipleRatingKeys;
  // final int photoBitrate;
  final String platform;
  final int ratingKey;
  final String rootTitle;
  final String state;
  final int syncId;
  final String syncMediaType;
  final String syncTitle;
  final int totalSize;
  final String user;
  final int userId;
  final String username;
  // final int videoBitrate;
  final int videoQuality;
  final String posterUrl;

  SyncedItem({
    // this.audioBitrate,
    this.clientId,
    // this.contentType,
    this.deviceName,
    // this.failure,
    // this.itemDownloadedCount,
    // this.itemDownloadedPercentComplete,
    this.itemCompleteCount,
    // this.itemCount,
    this.mediaType,
    this.multipleRatingKeys,
    // this.photoBitrate,
    this.platform,
    this.ratingKey,
    this.rootTitle,
    this.state,
    this.syncId,
    this.syncMediaType,
    this.syncTitle,
    this.totalSize,
    this.user,
    this.userId,
    this.username,
    // this.videoBitrate,
    this.videoQuality,
    this.posterUrl,
  });

  SyncedItem copyWith({
    String posterUrl,
  }) {
    return SyncedItem(
      // audioBitrate: this.audioBitrate,
      clientId: this.clientId,
      // contentType: this.contentType,
      deviceName: this.deviceName,
      // failure: this.failure,
      // itemDownloadedCount: this.itemDownloadedCount,
      // itemDownloadedPercentComplete: this.itemDownloadedPercentComplete,
      itemCompleteCount: this.itemCompleteCount,
      // itemCount: this.itemCount,
      mediaType: this.mediaType,
      multipleRatingKeys: this.multipleRatingKeys,
      // photoBitrate: this.photoBitrate,
      platform: this.platform,
      ratingKey: this.ratingKey,
      rootTitle: this.rootTitle,
      state: this.state,
      syncId: this.syncId,
      syncMediaType: this.syncMediaType,
      syncTitle: this.syncTitle,
      totalSize: this.totalSize,
      user: this.user,
      userId: this.userId,
      username: this.username,
      // videoBitrate: this.videoBitrate,
      videoQuality: this.videoQuality,
      posterUrl: posterUrl,
    );
  }

  @override
  List<Object> get props => [
        // audioBitrate,
        clientId,
        // contentType,
        deviceName,
        // failure,
        // itemDownloadedCount,
        // itemDownloadedPercentComplete,
        itemCompleteCount,
        // itemCount,
        mediaType,
        multipleRatingKeys,
        // photoBitrate,
        platform,
        ratingKey,
        rootTitle,
        state,
        syncId,
        syncMediaType,
        syncTitle,
        totalSize,
        user,
        userId,
        username,
        // videoBitrate,
        videoQuality,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
