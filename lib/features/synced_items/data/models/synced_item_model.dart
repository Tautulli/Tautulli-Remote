import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/synced_item.dart';

class SyncedItemModel extends SyncedItem {
  SyncedItemModel({
    // final int audioBitrate,
    final String clientId,
    // final String contentType,
    final String deviceName,
    // final String failure,
    // final int itemDownloadedCount,
    // final int itemDownloadedPercentComplete,
    final int itemCompleteCount,
    // final int itemCount,
    final String mediaType,
    final bool multipleRatingKeys,
    // final int photoBitrate,
    final String platform,
    final int ratingKey,
    final String rootTitle,
    final String state,
    final int syncId,
    final String syncMediaType,
    final String syncTitle,
    final int totalSize,
    final String user,
    final int userId,
    final String username,
    // final int videoBitrate,
    final int videoQuality,
    final String posterUrl,
  }) : super(
          // audioBitrate: audioBitrate,
          clientId: clientId,
          // contentType: contentType,
          deviceName: deviceName,
          // failure: failure,
          // itemDownloadedCount: itemDownloadedCount,
          // itemDownloadedPercentComplete: itemDownloadedPercentComplete,
          itemCompleteCount: itemCompleteCount,
          // itemCount: itemCount,
          mediaType: mediaType,
          multipleRatingKeys: multipleRatingKeys,
          // photoBitrate: photoBitrate,
          platform: platform,
          ratingKey: ratingKey,
          rootTitle: rootTitle,
          state: state,
          syncId: syncId,
          syncMediaType: syncMediaType,
          syncTitle: syncTitle,
          totalSize: totalSize,
          user: user,
          userId: userId,
          username: username,
          // videoBitrate: videoBitrate,
          videoQuality: videoQuality,
          posterUrl: posterUrl,
        );

  factory SyncedItemModel.fromJson(Map<String, dynamic> json) {
    final bool multipleRatingKeys = json['rating_key'].toString().contains(',');

    return SyncedItemModel(
      clientId: ValueHelper.cast(
        value: json['client_id'],
        type: CastType.string,
      ),
      deviceName: ValueHelper.cast(
        value: json['device_name'],
        type: CastType.string,
      ),
      itemCompleteCount: ValueHelper.cast(
        value: json['item_complete_count'],
        type: CastType.int,
      ),
      mediaType: ValueHelper.cast(
        value: json['metadata_type'],
        type: CastType.string,
      ),
      multipleRatingKeys: multipleRatingKeys,
      platform: ValueHelper.cast(
        value: json['platform'],
        type: CastType.string,
      ),
      // Use the first rating key if rating key is comma separated
      ratingKey: multipleRatingKeys
          ? int.tryParse(json['rating_key'].toString().split(',')[0])
          : ValueHelper.cast(
              value: json['rating_key'],
              type: CastType.int,
            ),
      rootTitle: ValueHelper.cast(
        value: json['root_title'],
        type: CastType.string,
      ),
      state: ValueHelper.cast(
        value: json['state'],
        type: CastType.string,
      ),
      syncId: ValueHelper.cast(
        value: json['sync_id'],
        type: CastType.int,
      ),
      syncMediaType: ValueHelper.cast(
        value: json['sync_media_type'],
        type: CastType.string,
      ),
      syncTitle: ValueHelper.cast(
        value: json['sync_title'],
        type: CastType.string,
      ),
      totalSize: ValueHelper.cast(
        value: json['total_size'],
        type: CastType.int,
      ),
      user: ValueHelper.cast(
        value: json['user'],
        type: CastType.string,
      ),
      userId: ValueHelper.cast(
        value: json['user_id'],
        type: CastType.int,
      ),
      username: ValueHelper.cast(
        value: json['username'],
        type: CastType.string,
      ),
      videoQuality: ValueHelper.cast(
        value: json['video_quality'],
        type: CastType.int,
      ),
    );
  }
}
