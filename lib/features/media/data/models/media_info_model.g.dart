// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInfoModel _$MediaInfoModelFromJson(Map<String, dynamic> json) =>
    MediaInfoModel(
      aspectRatio: Cast.castToDouble(json['aspect_ratio']),
      audioChannelLayout: Cast.castToString(json['audio_channel_layout']),
      audioChannels: Cast.castToInt(json['audio_channels']),
      audioCodec: Cast.castToString(json['audio_codec']),
      audioProfile: Cast.castToString(json['audio_profile']),
      bitrate: Cast.castToInt(json['bitrate']),
      channelCallSign: Cast.castToString(json['channel_call_sign']),
      channelIdentifier: Cast.castToString(json['channel_identifier']),
      channelThumb: Cast.castToString(json['channel_thumb']),
      container: Cast.castToString(json['container']),
      height: Cast.castToInt(json['height']),
      id: Cast.castToInt(json['id']),
      optimizedVersion: Cast.castToBool(json['optimized_version']),
      videoCodec: Cast.castToString(json['video_codec']),
      videoFramerate: Cast.castToString(json['video_framerate']),
      videoFullResolution: Cast.castToString(json['video_full_resolution']),
      videoProfile: Cast.castToString(json['video_profile']),
      videoResolution: Cast.castToString(json['video_resolution']),
      width: Cast.castToInt(json['width']),
    );

Map<String, dynamic> _$MediaInfoModelToJson(MediaInfoModel instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'audio_channel_layout': instance.audioChannelLayout,
      'audio_channels': instance.audioChannels,
      'audio_codec': instance.audioCodec,
      'audio_profile': instance.audioProfile,
      'bitrate': instance.bitrate,
      'channel_call_sign': instance.channelCallSign,
      'channel_identifier': instance.channelIdentifier,
      'channel_thumb': instance.channelThumb,
      'container': instance.container,
      'height': instance.height,
      'id': instance.id,
      'optimized_version': instance.optimizedVersion,
      'video_codec': instance.videoCodec,
      'video_framerate': instance.videoFramerate,
      'video_full_resolution': instance.videoFullResolution,
      'video_profile': instance.videoProfile,
      'video_resolution': instance.videoResolution,
      'width': instance.width,
    };
