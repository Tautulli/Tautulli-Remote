import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/location.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/types/playback_state.dart';
import '../../../../core/types/stream_decision.dart';
import '../../../../core/types/subtitle_decision.dart';
import '../../../../core/utilities/cast.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel extends Equatable {
  @JsonKey(name: 'audio_channel_layout', fromJson: Cast.castToString)
  final String? audioChannelLayout;
  @JsonKey(name: 'audio_codec', fromJson: Cast.castToString)
  final String? audioCodec;
  @JsonKey(name: 'audio_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? audioDecision;
  @JsonKey(name: 'audio_language', fromJson: Cast.castToString)
  final String? audioLanguage;
  @JsonKey(name: 'bandwidth', fromJson: Cast.castToInt)
  final int? bandwidth;
  @JsonKey(name: 'channel_call_sign', fromJson: Cast.castToString)
  final String? channelCallSign;
  @JsonKey(name: 'container', fromJson: Cast.castToString)
  final String? container;
  @JsonKey(name: 'container_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? containerDecision;
  @JsonKey(name: 'duration', fromJson: durationFromJson)
  final Duration? duration;
  @JsonKey(name: 'friendly_name', fromJson: Cast.castToString)
  final String? friendlyName;
  final Uri? grandparentImageUri;
  @JsonKey(name: 'grandparent_rating_key', fromJson: Cast.castToInt)
  final int? grandparentRatingKey;
  @JsonKey(name: 'grandparent_thumb', fromJson: Cast.castToString)
  final String? grandparentThumb;
  @JsonKey(name: 'grandparent_title', fromJson: Cast.castToString)
  final String? grandparentTitle;
  @JsonKey(name: 'height', fromJson: Cast.castToInt)
  final int? height;
  final Uri? imageUri;
  @JsonKey(name: 'ip_address', fromJson: Cast.castToString)
  final String? ipAddress;
  @JsonKey(name: 'live', fromJson: Cast.castToBool)
  final bool? live;
  @JsonKey(name: 'local', fromJson: Cast.castToBool)
  final bool? local;
  @JsonKey(name: 'location', fromJson: Cast.castStringToLocation)
  final Location? location;
  @JsonKey(name: 'media_index', fromJson: Cast.castToInt)
  final int? mediaIndex;
  @JsonKey(name: 'media_type', fromJson: Cast.castStringToMediaType)
  final MediaType? mediaType;
  @JsonKey(name: 'optimized_version', fromJson: Cast.castToBool)
  final bool? optimizedVersion;
  @JsonKey(name: 'optimized_version_profile', fromJson: Cast.castToString)
  final String? optimizedVersionProfile;
  @JsonKey(name: 'optimized_version_title', fromJson: Cast.castToString)
  final String? optimizedVersionTitle;
  @JsonKey(name: 'originally_available_at', fromJson: dateTimeFromString)
  final DateTime? originallyAvailableAt;
  final Uri? parentImageUri;
  @JsonKey(name: 'parent_media_index', fromJson: Cast.castToInt)
  final int? parentMediaIndex;
  @JsonKey(name: 'parent_rating_key', fromJson: Cast.castToInt)
  final int? parentRatingKey;
  @JsonKey(name: 'parent_thumb', fromJson: Cast.castToString)
  final String? parentThumb;
  @JsonKey(name: 'parent_title', fromJson: Cast.castToString)
  final String? parentTitle;
  @JsonKey(name: 'platform', fromJson: Cast.castToString)
  final String? platform;
  @JsonKey(name: 'platform_name', fromJson: Cast.castToString)
  final String? platformName;
  @JsonKey(name: 'player', fromJson: Cast.castToString)
  final String? player;
  @JsonKey(name: 'product', fromJson: Cast.castToString)
  final String? product;
  @JsonKey(name: 'progress_percent', fromJson: Cast.castToInt)
  final int? progressPercent;
  @JsonKey(name: 'quality_profile', fromJson: Cast.castToString)
  final String? qualityProfile;
  @JsonKey(name: 'rating_key', fromJson: Cast.castToInt)
  final int? ratingKey;
  @JsonKey(name: 'relay', fromJson: Cast.castToBool)
  final bool? relay;
  @JsonKey(name: 'secure', fromJson: Cast.castToBool)
  final bool? secure;
  @JsonKey(name: 'session_id', fromJson: Cast.castToString)
  final String? sessionId;
  @JsonKey(name: 'session_key', fromJson: Cast.castToInt)
  final int? sessionKey;
  @JsonKey(name: 'state', fromJson: Cast.castStringToPlaybackState)
  final PlaybackState? state;
  @JsonKey(name: 'stream_audio_channel_layout', fromJson: Cast.castToString)
  final String? streamAudioChannelLayout;
  @JsonKey(name: 'stream_audio_codec', fromJson: Cast.castToString)
  final String? streamAudioCodec;
  @JsonKey(name: 'stream_audio_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? streamAudioDecision;
  @JsonKey(name: 'stream_bitrate', fromJson: Cast.castToInt)
  final int? streamBitrate;
  @JsonKey(name: 'stream_container', fromJson: Cast.castToString)
  final String? streamContainer;
  @JsonKey(name: 'stream_container_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? streamContainerDecision;
  @JsonKey(name: 'stream_subtitle_codec', fromJson: Cast.castToString)
  final String? streamSubtitleCodec;
  @JsonKey(name: 'stream_subtitle_decision', fromJson: Cast.castStringToSubtitleDecision)
  final SubtitleDecision? streamSubtitleDecision;
  @JsonKey(name: 'stream_video_codec', fromJson: Cast.castToString)
  final String? streamVideoCodec;
  @JsonKey(name: 'stream_video_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? streamVideoDecision;
  @JsonKey(name: 'stream_video_dynamic_range', fromJson: Cast.castToString)
  final String? streamVideoDynamicRange;
  @JsonKey(name: 'stream_video_full_resolution', fromJson: Cast.castToString)
  final String? streamVideoFullResolution;
  @JsonKey(name: 'subtitle_codec', fromJson: Cast.castToString)
  final String? subtitleCodec;
  @JsonKey(name: 'subtitle_language', fromJson: Cast.castToString)
  final String? subtitleLanguage;
  @JsonKey(name: 'subtitles', fromJson: Cast.castToBool)
  final bool? subtitles;
  @JsonKey(name: 'sub_type', fromJson: Cast.castToString)
  final String? subType;
  @JsonKey(name: 'throttled', fromJson: Cast.castToBool)
  final bool? throttled;
  @JsonKey(name: 'thumb', fromJson: Cast.castToString)
  final String? thumb;
  @JsonKey(name: 'title', fromJson: Cast.castToString)
  final String? title;
  @JsonKey(name: 'transcode_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? transcodeDecision;
  @JsonKey(name: 'transcode_hw_decoding', fromJson: Cast.castToBool)
  final bool? transcodeHwDecoding;
  @JsonKey(name: 'transcode_hw_encoding', fromJson: Cast.castToBool)
  final bool? transcodeHwEncoding;
  @JsonKey(name: 'transcode_max_offset_available', fromJson: Cast.castToInt)
  final int? transcodeMaxOffsetAvailable;
  @JsonKey(name: 'transcode_progress', fromJson: Cast.castToInt)
  final int? transcodeProgress;
  @JsonKey(name: 'transcode_speed', fromJson: Cast.castToDouble)
  final double? transcodeSpeed;
  @JsonKey(name: 'transcode_trottled', fromJson: Cast.castToBool)
  final bool? transcodeThrottled;
  @JsonKey(name: 'user_id', fromJson: Cast.castToInt)
  final int? userId;
  @JsonKey(name: 'user_thumb', fromJson: Cast.castToString)
  final String? userThumb;
  @JsonKey(name: 'video_codec', fromJson: Cast.castToString)
  final String? videoCodec;
  @JsonKey(name: 'video_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? videoDecision;
  @JsonKey(name: 'video_dynamic_range', fromJson: Cast.castToString)
  final String? videoDynamicRange;
  @JsonKey(name: 'video_full_resolution', fromJson: Cast.castToString)
  final String? videoFullResolution;
  @JsonKey(name: 'view_offset', fromJson: Cast.castToInt)
  final int? viewOffset;
  @JsonKey(name: 'width', fromJson: Cast.castToInt)
  final int? width;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const ActivityModel({
    this.audioChannelLayout,
    this.audioCodec,
    this.audioDecision,
    this.audioLanguage,
    this.bandwidth,
    this.channelCallSign,
    this.container,
    this.containerDecision,
    this.duration,
    this.friendlyName,
    this.grandparentImageUri,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.height,
    this.imageUri,
    this.ipAddress,
    this.live,
    this.local,
    this.location,
    this.mediaIndex,
    this.mediaType,
    this.optimizedVersion,
    this.optimizedVersionProfile,
    this.optimizedVersionTitle,
    this.originallyAvailableAt,
    this.parentImageUri,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.platform,
    this.platformName,
    this.player,
    this.product,
    this.progressPercent,
    this.qualityProfile,
    this.ratingKey,
    this.relay,
    this.secure,
    this.sessionId,
    this.sessionKey,
    this.state,
    this.streamAudioChannelLayout,
    this.streamAudioCodec,
    this.streamAudioDecision,
    this.streamBitrate,
    this.streamContainer,
    this.streamContainerDecision,
    this.streamSubtitleCodec,
    this.streamSubtitleDecision,
    this.streamVideoCodec,
    this.streamVideoDecision,
    this.streamVideoDynamicRange,
    this.streamVideoFullResolution,
    this.subtitleCodec,
    this.subtitleLanguage,
    this.subtitles,
    this.subType,
    this.throttled,
    this.thumb,
    this.title,
    this.transcodeDecision,
    this.transcodeHwDecoding,
    this.transcodeHwEncoding,
    this.transcodeMaxOffsetAvailable,
    this.transcodeProgress,
    this.transcodeSpeed,
    this.transcodeThrottled,
    this.userId,
    this.userThumb,
    this.videoCodec,
    this.videoDecision,
    this.videoDynamicRange,
    this.videoFullResolution,
    this.viewOffset,
    this.width,
    this.year,
  });

  ActivityModel copyWith({
    final String? audioChannelLayout,
    final String? audioCodec,
    final StreamDecision? audioDecision,
    final String? audioLanguage,
    final int? bandwidth,
    final String? channelCallSign,
    final String? container,
    final StreamDecision? containerDecision,
    final Duration? duration,
    final String? friendlyName,
    final Uri? grandparentImageUri,
    final int? grandparentRatingKey,
    final String? grandparentThumb,
    final String? grandparentTitle,
    final int? height,
    final Uri? imageUri,
    final String? ipAddress,
    final bool? live,
    final bool? local,
    final Location? location,
    final int? mediaIndex,
    final MediaType? mediaType,
    final bool? optimizedVersion,
    final String? optimizedVersionProfile,
    final String? optimizedVersionTitle,
    final DateTime? originallyAvailableAt,
    final Uri? parentImageUri,
    final int? parentMediaIndex,
    final int? parentRatingKey,
    final String? parentThumb,
    final String? parentTitle,
    final String? platform,
    final String? platformName,
    final String? player,
    final String? product,
    final int? progressPercent,
    final String? qualityProfile,
    final int? ratingKey,
    final bool? relay,
    final bool? secure,
    final String? sessionId,
    final int? sessionKey,
    final PlaybackState? state,
    final String? streamAudioChannelLayout,
    final String? streamAudioCodec,
    final StreamDecision? streamAudioDecision,
    final int? streamBitrate,
    final String? streamContainer,
    final StreamDecision? streamContainerDecision,
    final String? streamSubtitleCodec,
    final SubtitleDecision? streamSubtitleDecision,
    final String? streamVideoCodec,
    final StreamDecision? streamVideoDecision,
    final String? streamVideoDynamicRange,
    final String? streamVideoFullResolution,
    final String? subtitleCodec,
    final String? subtitleLanguage,
    final bool? subtitles,
    final String? subType,
    final bool? throttled,
    final String? thumb,
    final String? title,
    final StreamDecision? transcodeDecision,
    final bool? transcodeHwDecoding,
    final bool? transcodeHwEncoding,
    final int? transcodeMaxOffsetAvailable,
    final int? transcodeProgress,
    final double? transcodeSpeed,
    final bool? transcodeThrottled,
    final int? userId,
    final String? userThumb,
    final String? videoCodec,
    final StreamDecision? videoDecision,
    final String? videoDynamicRange,
    final String? videoFullResolution,
    final int? viewOffset,
    final int? width,
    final int? year,
  }) {
    return ActivityModel(
      audioChannelLayout: audioChannelLayout ?? this.audioChannelLayout,
      audioCodec: audioCodec ?? this.audioCodec,
      audioDecision: audioDecision ?? this.audioDecision,
      audioLanguage: audioLanguage ?? this.audioLanguage,
      bandwidth: bandwidth ?? this.bandwidth,
      channelCallSign: channelCallSign ?? this.channelCallSign,
      container: container ?? this.container,
      containerDecision: containerDecision ?? this.containerDecision,
      duration: duration ?? this.duration,
      friendlyName: friendlyName ?? this.friendlyName,
      grandparentImageUri: grandparentImageUri ?? this.grandparentImageUri,
      grandparentRatingKey: grandparentRatingKey ?? this.grandparentRatingKey,
      grandparentThumb: grandparentThumb ?? this.grandparentThumb,
      grandparentTitle: grandparentTitle ?? this.grandparentTitle,
      height: height ?? this.height,
      imageUri: imageUri ?? this.imageUri,
      ipAddress: ipAddress ?? this.ipAddress,
      live: live ?? this.live,
      local: local ?? this.local,
      location: location ?? this.location,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      optimizedVersion: optimizedVersion ?? this.optimizedVersion,
      optimizedVersionProfile: optimizedVersionProfile ?? this.optimizedVersionProfile,
      optimizedVersionTitle: optimizedVersionTitle ?? this.optimizedVersionTitle,
      originallyAvailableAt: originallyAvailableAt ?? this.originallyAvailableAt,
      parentImageUri: parentImageUri ?? this.parentImageUri,
      parentMediaIndex: parentMediaIndex ?? this.parentMediaIndex,
      parentRatingKey: parentRatingKey ?? this.parentRatingKey,
      parentThumb: parentThumb ?? this.parentThumb,
      parentTitle: parentTitle ?? this.parentTitle,
      platform: platform ?? this.platform,
      platformName: platformName ?? this.platformName,
      player: player ?? this.player,
      product: product ?? this.product,
      progressPercent: progressPercent ?? this.progressPercent,
      qualityProfile: qualityProfile ?? this.qualityProfile,
      ratingKey: ratingKey ?? this.ratingKey,
      relay: relay ?? this.relay,
      secure: secure ?? this.secure,
      sessionId: sessionId ?? this.sessionId,
      sessionKey: sessionKey ?? this.sessionKey,
      state: state ?? this.state,
      streamAudioChannelLayout: streamAudioChannelLayout ?? this.streamAudioChannelLayout,
      streamAudioCodec: streamAudioCodec ?? this.streamAudioCodec,
      streamAudioDecision: streamAudioDecision ?? this.streamAudioDecision,
      streamBitrate: streamBitrate ?? this.streamBitrate,
      streamContainer: streamContainer ?? this.streamContainer,
      streamContainerDecision: streamContainerDecision ?? this.streamContainerDecision,
      streamSubtitleCodec: streamSubtitleCodec ?? this.streamSubtitleCodec,
      streamSubtitleDecision: streamSubtitleDecision ?? this.streamSubtitleDecision,
      streamVideoCodec: streamVideoCodec ?? this.streamVideoCodec,
      streamVideoDecision: streamVideoDecision ?? this.streamVideoDecision,
      streamVideoDynamicRange: streamVideoDynamicRange ?? this.streamVideoDynamicRange,
      streamVideoFullResolution: streamVideoFullResolution ?? this.streamVideoFullResolution,
      subtitleCodec: subtitleCodec ?? this.subtitleCodec,
      subtitleLanguage: subtitleLanguage ?? this.subtitleLanguage,
      subtitles: subtitles ?? this.subtitles,
      subType: subType ?? this.subType,
      throttled: throttled ?? this.throttled,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      transcodeDecision: transcodeDecision ?? this.transcodeDecision,
      transcodeHwDecoding: transcodeHwDecoding ?? this.transcodeHwDecoding,
      transcodeHwEncoding: transcodeHwEncoding ?? this.transcodeHwEncoding,
      transcodeMaxOffsetAvailable: transcodeMaxOffsetAvailable ?? this.transcodeMaxOffsetAvailable,
      transcodeProgress: transcodeProgress ?? this.transcodeProgress,
      transcodeSpeed: transcodeSpeed ?? this.transcodeSpeed,
      transcodeThrottled: transcodeThrottled ?? this.transcodeThrottled,
      userId: userId ?? this.userId,
      userThumb: userThumb ?? this.userThumb,
      videoCodec: videoCodec ?? this.videoCodec,
      videoDecision: videoDecision ?? this.videoDecision,
      videoDynamicRange: videoDynamicRange ?? this.videoDynamicRange,
      videoFullResolution: videoFullResolution ?? this.videoFullResolution,
      viewOffset: viewOffset ?? this.viewOffset,
      width: width ?? this.width,
      year: year ?? this.year,
    );
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  static DateTime? dateTimeFromString(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  static Duration? durationFromJson(String? millisecondsString) {
    final milliseconds = Cast.castToInt(millisecondsString);

    if (milliseconds == null) return null;

    return Duration(milliseconds: milliseconds);
  }

  @override
  List<Object?> get props => [
        audioChannelLayout,
        audioCodec,
        audioDecision,
        audioLanguage,
        bandwidth,
        channelCallSign,
        container,
        containerDecision,
        duration,
        friendlyName,
        grandparentImageUri,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        height,
        imageUri,
        ipAddress,
        live,
        local,
        location,
        mediaIndex,
        mediaType,
        optimizedVersion,
        optimizedVersionProfile,
        optimizedVersionTitle,
        originallyAvailableAt,
        parentImageUri,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        platform,
        platformName,
        player,
        product,
        progressPercent,
        qualityProfile,
        ratingKey,
        relay,
        secure,
        sessionId,
        sessionKey,
        state,
        streamAudioChannelLayout,
        streamAudioCodec,
        streamAudioDecision,
        streamBitrate,
        streamContainer,
        streamContainerDecision,
        streamSubtitleCodec,
        streamSubtitleDecision,
        streamVideoCodec,
        streamVideoDecision,
        streamVideoDynamicRange,
        streamVideoFullResolution,
        subtitleCodec,
        subtitleLanguage,
        subtitles,
        subType,
        throttled,
        thumb,
        title,
        transcodeDecision,
        transcodeHwDecoding,
        transcodeHwEncoding,
        transcodeProgress,
        transcodeMaxOffsetAvailable,
        transcodeSpeed,
        transcodeThrottled,
        userId,
        userThumb,
        videoCodec,
        videoDecision,
        videoDynamicRange,
        videoFullResolution,
        viewOffset,
        width,
        year,
      ];
}
