import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/location.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/types/playback_state.dart';
import '../../../../core/types/stream_decision.dart';
import '../../../../core/utilities/cast.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel extends Equatable {
  @JsonKey(name: 'audio_codec', fromJson: Cast.castToString)
  final String? audioCodec;
  @JsonKey(name: 'audio_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? audioDecision;
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
  @JsonKey(name: 'stream_audio_codec', fromJson: Cast.castToString)
  final String? streamAudioCodec;
  @JsonKey(name: 'stream_audio_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? streamAudioDecision;
  @JsonKey(name: 'stream_container', fromJson: Cast.castToString)
  final String? streamContainer;
  @JsonKey(name: 'stream_container_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? streamContainerDecision;
  @JsonKey(name: 'stream_video_codec', fromJson: Cast.castToString)
  final String? streamVideoCodec;
  @JsonKey(name: 'stream_video_decision', fromJson: Cast.castStringToStreamDecision)
  final StreamDecision? streamVideoDecision;
  @JsonKey(name: 'stream_video_dynamic_range', fromJson: Cast.castToString)
  final String? streamVideoDynamicRange;
  @JsonKey(name: 'subtitles', fromJson: Cast.castToBool)
  final bool? subtitles;
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
  @JsonKey(name: 'view_offset', fromJson: Cast.castToInt)
  final int? viewOffset;
  @JsonKey(name: 'year', fromJson: Cast.castToInt)
  final int? year;

  const ActivityModel({
    this.audioCodec,
    this.audioDecision,
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
    this.imageUri,
    this.ipAddress,
    this.live,
    this.local,
    this.location,
    this.mediaIndex,
    this.mediaType,
    this.optimizedVersion,
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
    this.ratingKey,
    this.relay,
    this.secure,
    this.sessionId,
    this.sessionKey,
    this.state,
    this.streamAudioCodec,
    this.streamAudioDecision,
    this.streamContainer,
    this.streamContainerDecision,
    this.streamVideoCodec,
    this.streamVideoDecision,
    this.streamVideoDynamicRange,
    this.subtitles,
    this.throttled,
    this.thumb,
    this.title,
    this.transcodeDecision,
    this.transcodeHwDecoding,
    this.transcodeHwEncoding,
    this.transcodeProgress,
    this.transcodeSpeed,
    this.transcodeThrottled,
    this.userId,
    this.userThumb,
    this.videoCodec,
    this.videoDecision,
    this.videoDynamicRange,
    this.viewOffset,
    this.year,
  });

  ActivityModel copyWith({
    final String? audioCodec,
    final StreamDecision? audioDecision,
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
    final Uri? imageUri,
    final String? ipAddress,
    final bool? live,
    final bool? local,
    final Location? location,
    final int? mediaIndex,
    final MediaType? mediaType,
    final bool? optimizedVersion,
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
    final int? ratingKey,
    final bool? relay,
    final bool? secure,
    final String? sessionId,
    final int? sessionKey,
    final PlaybackState? state,
    final String? streamAudioCodec,
    final StreamDecision? streamAudioDecision,
    final String? streamContainer,
    final StreamDecision? streamContainerDecision,
    final String? streamVideoCodec,
    final StreamDecision? streamVideoDecision,
    final String? streamVideoDynamicRange,
    final bool? subtitles,
    final bool? throttled,
    final String? thumb,
    final String? title,
    final StreamDecision? transcodeDecision,
    final bool? transcodeHwDecoding,
    final bool? transcodeHwEncoding,
    final int? transcodeProgress,
    final double? transcodeSpeed,
    final bool? transcodeThrottled,
    final int? userId,
    final String? userThumb,
    final String? videoCodec,
    final StreamDecision? videoDecision,
    final String? videoDynamicRange,
    final int? viewOffset,
    final int? year,
  }) {
    return ActivityModel(
      audioCodec: audioCodec ?? this.audioCodec,
      audioDecision: audioDecision ?? this.audioDecision,
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
      imageUri: imageUri ?? this.imageUri,
      ipAddress: ipAddress ?? this.ipAddress,
      live: live ?? this.live,
      local: local ?? this.local,
      location: location ?? this.location,
      mediaIndex: mediaIndex ?? this.mediaIndex,
      mediaType: mediaType ?? this.mediaType,
      optimizedVersion: optimizedVersion ?? this.optimizedVersion,
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
      ratingKey: ratingKey ?? this.ratingKey,
      relay: relay ?? this.relay,
      secure: secure ?? this.secure,
      sessionId: sessionId ?? this.sessionId,
      sessionKey: sessionKey ?? this.sessionKey,
      state: state ?? this.state,
      streamAudioCodec: streamAudioCodec ?? this.streamAudioCodec,
      streamAudioDecision: streamAudioDecision ?? this.streamAudioDecision,
      streamContainer: streamContainer ?? this.streamContainer,
      streamContainerDecision: streamContainerDecision ?? this.streamContainerDecision,
      streamVideoCodec: streamVideoCodec ?? this.streamVideoCodec,
      streamVideoDecision: streamVideoDecision ?? this.streamVideoDecision,
      streamVideoDynamicRange: streamVideoDynamicRange ?? this.streamVideoDynamicRange,
      subtitles: subtitles ?? this.subtitles,
      throttled: throttled ?? this.throttled,
      thumb: thumb ?? this.thumb,
      title: title ?? this.title,
      transcodeDecision: transcodeDecision ?? this.transcodeDecision,
      transcodeHwDecoding: transcodeHwDecoding ?? this.transcodeHwDecoding,
      transcodeHwEncoding: transcodeHwEncoding ?? this.transcodeHwEncoding,
      transcodeProgress: transcodeProgress ?? this.transcodeProgress,
      transcodeSpeed: transcodeSpeed ?? this.transcodeSpeed,
      transcodeThrottled: transcodeThrottled ?? this.transcodeThrottled,
      userId: userId ?? this.userId,
      userThumb: userThumb ?? this.userThumb,
      videoCodec: videoCodec ?? this.videoCodec,
      videoDecision: videoDecision ?? this.videoDecision,
      videoDynamicRange: videoDynamicRange ?? this.videoDynamicRange,
      viewOffset: viewOffset ?? this.viewOffset,
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
        audioCodec,
        audioDecision,
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
        imageUri,
        ipAddress,
        live,
        local,
        location,
        mediaIndex,
        mediaType,
        optimizedVersion,
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
        ratingKey,
        relay,
        secure,
        sessionId,
        sessionKey,
        state,
        streamAudioCodec,
        streamAudioDecision,
        streamContainer,
        streamContainerDecision,
        streamVideoCodec,
        streamVideoDecision,
        streamVideoDynamicRange,
        subtitles,
        throttled,
        thumb,
        title,
        transcodeDecision,
        transcodeHwDecoding,
        transcodeHwEncoding,
        transcodeProgress,
        transcodeSpeed,
        transcodeThrottled,
        userId,
        userThumb,
        videoCodec,
        videoDecision,
        videoDynamicRange,
        viewOffset,
        year,
      ];
}
