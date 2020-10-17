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
  // final int photoBitrate;
  final String platform;
  final int ratingKey;
  final String rootTitle;
  final String state;
  final int syncId;
  final String syncTitle;
  final int totalSize;
  final String user;
  final int userId;
  final String username;
  // final int videoBitrate;
  final int videoQuality;
  String posterUrl;

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
    // this.photoBitrate,
    this.platform,
    this.ratingKey,
    this.rootTitle,
    this.state,
    this.syncId,
    this.syncTitle,
    this.totalSize,
    this.user,
    this.userId,
    this.username,
    // this.videoBitrate,
    this.videoQuality,
    this.posterUrl,
  });

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
        // photoBitrate,
        platform,
        ratingKey,
        rootTitle,
        state,
        syncId,
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
