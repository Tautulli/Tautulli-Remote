import 'package:meta/meta.dart';

import '../../domain/entities/activity.dart';
import '../../domain/entities/geo_ip.dart';

class ActivityItemModel extends ActivityItem {
  ActivityItemModel({
    @required final int sessionKey,
    final String art, // Image path for background art
    final String audioChannelLayout, // stereo, 5.1, etc
    final String audioCodec, // Source media audio codec
    final String bandwidth, // Streaming brain estimate for bandwidth
    final String channelCallSign,
    final String channelIdentifier,
    final String container, // Source media container (MKV, etc)
    final int duration, // Length of item in milliseconds
    final String friendlyName, // Tautulli friendly name
    final int grandparentRatingKey, // Used to get TV show poster
    final String grandparentThumb,
    final String grandparentTitle, // Show name
    final int height,
    final String ipAddress,
    final int live, // 1 if live tv
    final String location, // lan, wan
    final int mediaIndex, // Episode number
    final String mediaType, // movie, episode,
    final int optimizedVersion, // 1 if optimized version
    final String optimizedVersionProfile,
    final String optimizedVersionTitle,
    final String originallyAvailableAt,
    final int parentMediaIndex, // Season number
    final int parentRatingKey, // Used to get album art
    final String parentThumb,
    final String parentTitle, // Album name
    final String platformName, // Player platform (Chrome, etc)
    final String player, // Name of the player (ex. PC name)
    final String product, // Player product (Plex Media Player, etc)
    final int progressPercent, // Percent watched
    final String qualityProfile, // Streaming quality
    final int ratingKey, // Used to get movie poster
    final int relayed, // 1 if using Plex Relay
    final int secure, // 1 if connection is secure
    final int streamBitrate, // Streaming bitrate in kbps
    final String
        state, // Current state of the stream (paused/playing/buffering)
    final String streamAudioChannelLayout, // stereo, 5.1, etc
    final String streamAudioCodec, // Source media audio codec
    final String streamAudioDecision, // transcode, copy, direct play
    final String
        streamContainer, // Stream media container, will be different than container if transcoding
    final String streamContainerDecision, // Transcode or Direct Play
    final String streamSubtitleDecision, // transcode, copy, burn
    final String streamSubtitleCodec, // srt, ass, etc
    final String streamVideoCodec, // h264, etc
    final String streamVideoDecision, // transcode, copy, direct play
    final String streamVideoDynamicRange, // SDR, HDR
    final String streamVideoFullResolution, // 1080p, etc
    final String subtitleCodec, // srt, ass, etc
    final int subtitles, // 1 if subtitles are on
    final int syncedVersion, // 1 if is synced content
    final String syncedVersionProfile,
    final String thumb,
    final String title, // Movie name or Episode name
    final String transcodeDecision, // 'Transcode' if transcoding
    final int transcodeHwEncoding, // 1 if true
    final int transcodeHwDecoding, // 1 if true
    final int transcodeThrottled, // 1 if throttling
    final int transcodeProgress, // Percent transcoded
    final double transcodeSpeed, // Value is x factor
    final String username, // Plex username
    final String videoCodec, // h264, etc
    final String videoDynamicRange, // SDR, HDR
    final String videoFullResolution, // 1080p, etc
    final int viewOffset, // Time from begining of file in milliseconds
    final int width,
    final int year, // Release year
    GeoIpItem geoIpItem,
    String posterUrl,
    String posterBackgroundUrl,
    String backgroundUrl,
  }) : super(
          sessionKey: sessionKey,
          art: art,
          audioChannelLayout: audioChannelLayout,
          audioCodec: audioCodec,
          bandwidth: bandwidth,
          channelCallSign: channelCallSign,
          channelIdentifier: channelIdentifier,
          container: container,
          duration: duration,
          friendlyName: friendlyName,
          grandparentRatingKey: grandparentRatingKey,
          grandparentThumb: grandparentThumb,
          grandparentTitle: grandparentTitle,
          height: height,
          ipAddress: ipAddress,
          live: live,
          location: location,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          optimizedVersion: optimizedVersion,
          optimizedVersionProfile: optimizedVersionProfile,
          optimizedVersionTitle: optimizedVersionTitle,
          originallyAvailableAt: originallyAvailableAt,
          parentMediaIndex: parentMediaIndex,
          parentRatingKey: parentRatingKey,
          parentThumb: parentThumb,
          parentTitle: parentTitle,
          platformName: platformName,
          player: player,
          product: product,
          progressPercent: progressPercent,
          qualityProfile: qualityProfile,
          ratingKey: ratingKey,
          relayed: relayed,
          secure: secure,
          state: state,
          streamAudioChannelLayout: streamAudioChannelLayout,
          streamAudioCodec: streamAudioCodec,
          streamAudioDecision: streamAudioDecision,
          streamBitrate: streamBitrate,
          streamContainer: streamContainer,
          streamContainerDecision: streamContainerDecision,
          streamSubtitleCodec: streamSubtitleCodec,
          streamSubtitleDecision: streamSubtitleDecision,
          streamVideoCodec: streamVideoCodec,
          streamVideoDecision: streamVideoDecision,
          streamVideoDynamicRange: streamVideoDynamicRange,
          streamVideoFullResolution: streamVideoFullResolution,
          subtitleCodec: subtitleCodec,
          subtitles: subtitles,
          syncedVersion: syncedVersion,
          syncedVersionProfile: syncedVersionProfile,
          thumb: thumb,
          title: title,
          transcodeDecision: transcodeDecision,
          transcodeHwDecoding: transcodeHwDecoding,
          transcodeHwEncoding: transcodeHwEncoding,
          transcodeProgress: transcodeProgress,
          transcodeSpeed: transcodeSpeed,
          transcodeThrottled: transcodeThrottled,
          username: username,
          videoCodec: videoCodec,
          videoDynamicRange: videoDynamicRange,
          videoFullResolution: videoFullResolution,
          viewOffset: viewOffset,
          width: width,
          year: year,
          geoIpItem: geoIpItem,
          posterUrl: posterUrl,
          posterBackgroundUrl: posterBackgroundUrl,
          backgroundUrl: backgroundUrl,
        );

  factory ActivityItemModel.fromJson(Map<String, dynamic> json) {
    return ActivityItemModel(
      sessionKey: int.tryParse(json['session_key']),
      art: json['art'],
      audioChannelLayout: json['audio_channel_layout'],
      audioCodec: json['audio_codec'],
      bandwidth: json['bandwidth'],
      channelCallSign: json['channel_call_sign'],
      channelIdentifier: json['channel_identifier'],
      container: json['container'],
      duration: int.tryParse(json['duration']),
      friendlyName: json['friendly_name'],
      grandparentRatingKey: int.tryParse(json['grandparent_rating_key']),
      grandparentThumb: json['grandparent_thumb'],
      grandparentTitle: json['grandparent_title'],
      height: int.tryParse(json['height']),
      ipAddress: json['ip_address'],
      live: json['live'],
      location: json['location'],
      mediaIndex: int.tryParse(json['media_index']),
      mediaType: json['media_type'],
      optimizedVersion: json['optimized_version'],
      optimizedVersionProfile: json['optimized_version_profile'],
      optimizedVersionTitle: json['optimized_version_title'],
      originallyAvailableAt: json['originally_available_at'],
      parentMediaIndex: int.tryParse(json['parent_media_index']),
      parentRatingKey: int.tryParse(json['parent_rating_key']),
      parentThumb: json['parent_thumb'],
      parentTitle: json['parent_title'],
      platformName: json['platform_name'],
      player: json['player'],
      product: json['product'],
      progressPercent: int.tryParse(json['progress_percent']),
      qualityProfile: json['quality_profile'],
      ratingKey: int.tryParse(json['rating_key']),
      relayed: json['relayed'],
      secure: json['secure'],
      state: json['state'],
      streamAudioChannelLayout: json['stream_audio_channel_layout'],
      streamAudioCodec: json['stream_audio_codec'],
      streamAudioDecision: json['stream_audio_decision'],
      streamBitrate: int.tryParse(json['stream_bitrate']),
      streamContainer: json['stream_container'],
      streamContainerDecision: json['stream_container_decision'],
      streamSubtitleCodec: json['stream_subtitle_codec'],
      streamSubtitleDecision: json['stream_subtitle_decision'],
      streamVideoCodec: json['stream_video_codec'],
      streamVideoDecision: json['stream_video_decision'],
      streamVideoDynamicRange: json['stream_video_dynamic_range'],
      streamVideoFullResolution: json['stream_video_full_resolution'],
      subtitleCodec: json['subtitle_codec'],
      subtitles: json['subtitles'],
      syncedVersion: json['synced_version'],
      syncedVersionProfile: json['synced_version_profile'],
      thumb: json['thumb'],
      title: json['title'],
      transcodeDecision: json['transcode_decision'],
      transcodeHwDecoding: json['transcode_hw_decoding'],
      transcodeHwEncoding: json['transcode_hw_encoding'],
      transcodeProgress: json['transcode_progress'],
      transcodeSpeed: double.tryParse(json['transcode_speed']),
      transcodeThrottled: json['transcode_throttled'],
      username: json['username'],
      videoCodec: json['video_codec'],
      videoDynamicRange: json['video_dynamic_range'],
      videoFullResolution: json['video_full_resolution'],
      viewOffset: int.tryParse(json['view_offset']),
      width: int.tryParse(json['width']),
      year: int.tryParse(json['year']),
    );
  }
}
