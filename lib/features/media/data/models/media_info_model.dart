import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utilities/cast.dart';

part 'media_info_model.g.dart';

@JsonSerializable()
class MediaInfoModel extends Equatable {
  @JsonKey(name: 'aspect_ratio', fromJson: Cast.castToDouble)
  final double? aspectRatio;
  @JsonKey(name: 'audio_channel_layout', fromJson: Cast.castToString)
  final String? audioChannelLayout;
  @JsonKey(name: 'audio_channels', fromJson: Cast.castToInt)
  final int? audioChannels;
  @JsonKey(name: 'audio_codec', fromJson: Cast.castToString)
  final String? audioCodec;
  @JsonKey(name: 'audio_profile', fromJson: Cast.castToString)
  final String? audioProfile;
  @JsonKey(name: 'bitrate', fromJson: Cast.castToInt)
  final int? bitrate;
  @JsonKey(name: 'channel_call_sign', fromJson: Cast.castToString)
  final String? channelCallSign;
  @JsonKey(name: 'channel_identifier', fromJson: Cast.castToString)
  final String? channelIdentifier;
  @JsonKey(name: 'channel_thumb', fromJson: Cast.castToString)
  final String? channelThumb;
  @JsonKey(name: 'container', fromJson: Cast.castToString)
  final String? container;
  @JsonKey(name: 'height', fromJson: Cast.castToInt)
  final int? height;
  @JsonKey(name: 'id', fromJson: Cast.castToInt)
  final int? id;
  @JsonKey(name: 'optimized_version', fromJson: Cast.castToBool)
  final bool? optimizedVersion;
  @JsonKey(name: 'video_codec', fromJson: Cast.castToString)
  final String? videoCodec;
  @JsonKey(name: 'video_framerate', fromJson: Cast.castToString)
  final String? videoFramerate;
  @JsonKey(name: 'video_full_resolution', fromJson: Cast.castToString)
  final String? videoFullResolution;
  @JsonKey(name: 'video_profile', fromJson: Cast.castToString)
  final String? videoProfile;
  @JsonKey(name: 'video_resolution', fromJson: Cast.castToString)
  final String? videoResolution;
  @JsonKey(name: 'width', fromJson: Cast.castToInt)
  final int? width;

  const MediaInfoModel({
    this.aspectRatio,
    this.audioChannelLayout,
    this.audioChannels,
    this.audioCodec,
    this.audioProfile,
    this.bitrate,
    this.channelCallSign,
    this.channelIdentifier,
    this.channelThumb,
    this.container,
    this.height,
    this.id,
    this.optimizedVersion,
    this.videoCodec,
    this.videoFramerate,
    this.videoFullResolution,
    this.videoProfile,
    this.videoResolution,
    this.width,
  });

  MediaInfoModel copyWith({
    double? aspectRatio,
    String? audioChannelLayout,
    int? audioChannels,
    String? audioCodec,
    String? audioProfile,
    int? bitrate,
    String? channelCallSign,
    String? channelIdentifier,
    String? channelThumb,
    String? container,
    int? height,
    int? id,
    bool? optimizedVersion,
    String? videoCodec,
    String? videoFramerate,
    String? videoFullResolution,
    String? videoProfile,
    String? videoResolution,
    int? width,
  }) {
    return MediaInfoModel(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      audioChannelLayout: audioChannelLayout ?? this.audioChannelLayout,
      audioChannels: audioChannels ?? this.audioChannels,
      audioCodec: audioCodec ?? this.audioCodec,
      audioProfile: audioProfile ?? this.audioProfile,
      bitrate: bitrate ?? this.bitrate,
      channelCallSign: channelCallSign ?? this.channelCallSign,
      channelIdentifier: channelIdentifier ?? this.channelIdentifier,
      channelThumb: channelThumb ?? this.channelThumb,
      container: container ?? this.container,
      height: height ?? this.height,
      id: id ?? this.id,
      optimizedVersion: optimizedVersion ?? this.optimizedVersion,
      videoCodec: videoCodec ?? this.videoCodec,
      videoFramerate: videoFramerate ?? this.videoFramerate,
      videoFullResolution: videoFullResolution ?? this.videoFullResolution,
      videoProfile: videoProfile ?? this.videoProfile,
      videoResolution: videoResolution ?? this.videoResolution,
      width: width ?? this.width,
    );
  }

  factory MediaInfoModel.fromJson(Map<String, dynamic> json) => _$MediaInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaInfoModelToJson(this);

  @override
  List<Object?> get props => [
        aspectRatio,
        audioChannelLayout,
        audioChannels,
        audioCodec,
        audioProfile,
        bitrate,
        channelCallSign,
        channelIdentifier,
        channelThumb,
        container,
        height,
        id,
        optimizedVersion,
        videoCodec,
        videoFramerate,
        videoFullResolution,
        videoProfile,
        videoResolution,
        width,
      ];
}
