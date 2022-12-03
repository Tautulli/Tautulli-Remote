// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      audioCodec: Cast.castToString(json['audio_codec']),
      audioDecision:
          Cast.castStringToStreamDecision(json['audio_decision'] as String?),
      bandwidth: Cast.castToInt(json['bandwidth']),
      channelCallSign: Cast.castToString(json['channel_call_sign']),
      container: Cast.castToString(json['container']),
      containerDecision: Cast.castStringToStreamDecision(
          json['container_decision'] as String?),
      duration: ActivityModel.durationFromJson(json['duration'] as String?),
      friendlyName: Cast.castToString(json['friendly_name']),
      grandparentImageUri: json['grandparentImageUri'] == null
          ? null
          : Uri.parse(json['grandparentImageUri'] as String),
      grandparentRatingKey: Cast.castToInt(json['grandparent_rating_key']),
      grandparentThumb: Cast.castToString(json['grandparent_thumb']),
      grandparentTitle: Cast.castToString(json['grandparent_title']),
      imageUri: json['imageUri'] == null
          ? null
          : Uri.parse(json['imageUri'] as String),
      ipAddress: Cast.castToString(json['ip_address']),
      live: Cast.castToBool(json['live']),
      local: Cast.castToBool(json['local']),
      location: Cast.castStringToLocation(json['location'] as String?),
      mediaIndex: Cast.castToInt(json['media_index']),
      mediaType: Cast.castStringToMediaType(json['media_type'] as String?),
      optimizedVersion: Cast.castToBool(json['optimized_version']),
      originallyAvailableAt: ActivityModel.dateTimeFromString(
          json['originally_available_at'] as String?),
      parentImageUri: json['parentImageUri'] == null
          ? null
          : Uri.parse(json['parentImageUri'] as String),
      parentMediaIndex: Cast.castToInt(json['parent_media_index']),
      parentRatingKey: Cast.castToInt(json['parent_rating_key']),
      parentThumb: Cast.castToString(json['parent_thumb']),
      parentTitle: Cast.castToString(json['parent_title']),
      platform: Cast.castToString(json['platform']),
      platformName: Cast.castToString(json['platform_name']),
      player: Cast.castToString(json['player']),
      product: Cast.castToString(json['product']),
      progressPercent: Cast.castToInt(json['progress_percent']),
      ratingKey: Cast.castToInt(json['rating_key']),
      relay: Cast.castToBool(json['relay']),
      secure: Cast.castToBool(json['secure']),
      sessionId: Cast.castToString(json['session_id']),
      sessionKey: Cast.castToInt(json['session_key']),
      state: Cast.castStringToPlaybackState(json['state'] as String?),
      streamAudioCodec: Cast.castToString(json['stream_audio_codec']),
      streamAudioDecision: Cast.castStringToStreamDecision(
          json['stream_audio_decision'] as String?),
      streamContainer: Cast.castToString(json['stream_container']),
      streamContainerDecision: Cast.castStringToStreamDecision(
          json['stream_container_decision'] as String?),
      streamVideoCodec: Cast.castToString(json['stream_video_codec']),
      streamVideoDecision: Cast.castStringToStreamDecision(
          json['stream_video_decision'] as String?),
      streamVideoDynamicRange:
          Cast.castToString(json['stream_video_dynamic_range']),
      subtitles: Cast.castToBool(json['subtitles']),
      throttled: Cast.castToBool(json['throttled']),
      thumb: Cast.castToString(json['thumb']),
      title: Cast.castToString(json['title']),
      transcodeDecision: Cast.castStringToStreamDecision(
          json['transcode_decision'] as String?),
      transcodeHwDecoding: Cast.castToBool(json['transcode_hw_decoding']),
      transcodeHwEncoding: Cast.castToBool(json['transcode_hw_encoding']),
      transcodeProgress: Cast.castToInt(json['transcode_progress']),
      transcodeSpeed: Cast.castToDouble(json['transcode_speed']),
      transcodeThrottled: Cast.castToBool(json['transcode_trottled']),
      userId: Cast.castToInt(json['user_id']),
      userThumb: Cast.castToString(json['user_thumb']),
      videoCodec: Cast.castToString(json['video_codec']),
      videoDecision:
          Cast.castStringToStreamDecision(json['video_decision'] as String?),
      videoDynamicRange: Cast.castToString(json['video_dynamic_range']),
      viewOffset: Cast.castToInt(json['view_offset']),
      year: Cast.castToInt(json['year']),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'audio_codec': instance.audioCodec,
      'audio_decision': _$StreamDecisionEnumMap[instance.audioDecision],
      'bandwidth': instance.bandwidth,
      'channel_call_sign': instance.channelCallSign,
      'container': instance.container,
      'container_decision': _$StreamDecisionEnumMap[instance.containerDecision],
      'duration': instance.duration?.inMicroseconds,
      'friendly_name': instance.friendlyName,
      'grandparentImageUri': instance.grandparentImageUri?.toString(),
      'grandparent_rating_key': instance.grandparentRatingKey,
      'grandparent_thumb': instance.grandparentThumb,
      'grandparent_title': instance.grandparentTitle,
      'imageUri': instance.imageUri?.toString(),
      'ip_address': instance.ipAddress,
      'live': instance.live,
      'local': instance.local,
      'location': _$LocationEnumMap[instance.location],
      'media_index': instance.mediaIndex,
      'media_type': _$MediaTypeEnumMap[instance.mediaType],
      'optimized_version': instance.optimizedVersion,
      'originally_available_at':
          instance.originallyAvailableAt?.toIso8601String(),
      'parentImageUri': instance.parentImageUri?.toString(),
      'parent_media_index': instance.parentMediaIndex,
      'parent_rating_key': instance.parentRatingKey,
      'parent_thumb': instance.parentThumb,
      'parent_title': instance.parentTitle,
      'platform': instance.platform,
      'platform_name': instance.platformName,
      'player': instance.player,
      'product': instance.product,
      'progress_percent': instance.progressPercent,
      'rating_key': instance.ratingKey,
      'relay': instance.relay,
      'secure': instance.secure,
      'session_id': instance.sessionId,
      'session_key': instance.sessionKey,
      'state': _$PlaybackStateEnumMap[instance.state],
      'stream_audio_codec': instance.streamAudioCodec,
      'stream_audio_decision':
          _$StreamDecisionEnumMap[instance.streamAudioDecision],
      'stream_container': instance.streamContainer,
      'stream_container_decision':
          _$StreamDecisionEnumMap[instance.streamContainerDecision],
      'stream_video_codec': instance.streamVideoCodec,
      'stream_video_decision':
          _$StreamDecisionEnumMap[instance.streamVideoDecision],
      'stream_video_dynamic_range': instance.streamVideoDynamicRange,
      'subtitles': instance.subtitles,
      'throttled': instance.throttled,
      'thumb': instance.thumb,
      'title': instance.title,
      'transcode_decision': _$StreamDecisionEnumMap[instance.transcodeDecision],
      'transcode_hw_decoding': instance.transcodeHwDecoding,
      'transcode_hw_encoding': instance.transcodeHwEncoding,
      'transcode_progress': instance.transcodeProgress,
      'transcode_speed': instance.transcodeSpeed,
      'transcode_trottled': instance.transcodeThrottled,
      'user_id': instance.userId,
      'user_thumb': instance.userThumb,
      'video_codec': instance.videoCodec,
      'video_decision': _$StreamDecisionEnumMap[instance.videoDecision],
      'video_dynamic_range': instance.videoDynamicRange,
      'view_offset': instance.viewOffset,
      'year': instance.year,
    };

const _$StreamDecisionEnumMap = {
  StreamDecision.copy: 'copy',
  StreamDecision.directPlay: 'directPlay',
  StreamDecision.transcode: 'transcode',
  StreamDecision.unknown: 'unknown',
};

const _$LocationEnumMap = {
  Location.cellular: 'cellular',
  Location.lan: 'lan',
  Location.wan: 'wan',
  Location.unknown: 'unknown',
};

const _$MediaTypeEnumMap = {
  MediaType.album: 'album',
  MediaType.artist: 'artist',
  MediaType.clip: 'clip',
  MediaType.collection: 'collection',
  MediaType.episode: 'episode',
  MediaType.movie: 'movie',
  MediaType.otherVideo: 'otherVideo',
  MediaType.photo: 'photo',
  MediaType.photoAlbum: 'photoAlbum',
  MediaType.playlist: 'playlist',
  MediaType.season: 'season',
  MediaType.show: 'show',
  MediaType.track: 'track',
  MediaType.unknown: 'unknown',
};

const _$PlaybackStateEnumMap = {
  PlaybackState.buffering: 'buffering',
  PlaybackState.error: 'error',
  PlaybackState.paused: 'paused',
  PlaybackState.playing: 'playing',
  PlaybackState.unknown: 'unknown',
};
