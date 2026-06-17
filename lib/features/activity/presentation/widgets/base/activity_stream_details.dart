import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/types/stream_decision.dart';
import '../../../../../core/types/subtitle_decision.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/activity_model.dart';

String activityQualityText(ActivityModel activity) {
  String formattedBitrate = '';
  String finalText = '';

  if (activity.mediaType != MediaType.photo && activity.qualityProfile != 'Unknown') {
    if (activity.streamBitrate != null) {
      if (activity.streamBitrate! > 1000) {
        formattedBitrate = '${(activity.streamBitrate! / 1000).toStringAsFixed(1)} Mbps';
      } else {
        formattedBitrate = '${activity.streamBitrate} kbps';
      }
    }
  }

  if (activity.qualityProfile != null) {
    if (isNotBlank(formattedBitrate)) {
      finalText = '${activity.qualityProfile} ($formattedBitrate)';
    } else {
      finalText = activity.qualityProfile!;
    }
  }

  return finalText;
}

String activityStreamDecisionText(ActivityModel activity) {
  if (activity.transcodeDecision == StreamDecision.transcode) {
    if (activity.transcodeThrottled == true) {
      return '${LocaleKeys.transcode_title.tr()} (${LocaleKeys.throttled_title.tr()})';
    } else {
      return '${LocaleKeys.transcode_title.tr()} (${LocaleKeys.speed_title.tr()}: ${activity.transcodeSpeed})';
    }
  } else if (activity.transcodeDecision == StreamDecision.copy) {
    return LocaleKeys.direct_stream_title.tr();
  } else {
    return LocaleKeys.direct_play_title.tr();
  }
}

class ActivityStreamContainerItem extends StatelessWidget {
  final ActivityModel activity;
  final Widget icon;
  final Color textColor;

  const ActivityStreamContainerItem({
    super.key,
    required this.activity,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (activity.streamContainerDecision == StreamDecision.transcode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(LocaleKeys.converting_title).tr(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '${activity.container?.toUpperCase()}'),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: icon,
                  ),
                ),
                TextSpan(text: '${activity.streamContainer?.toUpperCase()}'),
              ],
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      );
    }

    return Text('${LocaleKeys.direct_play_title.tr()} (${activity.streamContainer?.toUpperCase()})');
  }
}

class ActivityStreamVideoItem extends StatelessWidget {
  final ActivityModel activity;
  final Widget icon;
  final Color textColor;

  const ActivityStreamVideoItem({
    super.key,
    required this.activity,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    String videoDynamicRange = '';
    String streamVideoDynamicRange = '';
    String hwD = '';
    String hwE = '';

    if ([
          MediaType.movie,
          MediaType.episode,
          MediaType.clip,
        ].contains(activity.mediaType) &&
        activity.streamVideoDecision != null) {
      if (activity.videoDynamicRange != 'SDR') {
        videoDynamicRange = ' ${activity.videoDynamicRange}';
        streamVideoDynamicRange = ' ${activity.streamVideoDynamicRange}';
      }

      if (activity.streamVideoDecision == StreamDecision.transcode) {
        if (activity.transcodeHwDecoding == true) {
          hwD = ' (HW)';
        }
        if (activity.transcodeHwEncoding == true) {
          hwE = ' (HW)';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(LocaleKeys.transcode_title).tr(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${activity.videoCodec?.toUpperCase()}$hwD ${activity.videoFullResolution}$videoDynamicRange',
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: icon,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${activity.streamVideoCodec?.toUpperCase()}$hwE ${activity.streamVideoFullResolution}$streamVideoDynamicRange',
                  ),
                ],
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      } else if (activity.streamVideoDecision == StreamDecision.copy) {
        return Text(
          '${LocaleKeys.direct_stream_title.tr()} (${activity.streamVideoCodec?.toUpperCase()} ${activity.streamVideoFullResolution}$streamVideoDynamicRange)',
        );
      } else {
        return Text(
          '${LocaleKeys.direct_play_title.tr()} (${activity.streamVideoCodec?.toUpperCase()} ${activity.streamVideoFullResolution}$streamVideoDynamicRange)',
        );
      }
    } else if (activity.mediaType == MediaType.photo) {
      return Text(
        '${LocaleKeys.direct_play_title.tr()} (${activity.width}x${activity.height})',
      );
    }

    return const Text('');
  }
}

class ActivityStreamAudioItem extends StatelessWidget {
  final ActivityModel activity;
  final Widget icon;
  final Color textColor;

  const ActivityStreamAudioItem({
    super.key,
    required this.activity,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool audioLanguageEmpty = isEmpty(activity.audioLanguage);

    if (activity.streamAudioDecision == StreamDecision.transcode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(LocaleKeys.transcode_title).tr(),
          RichText(
            text: TextSpan(
              children: [
                if (activity.audioChannelLayout != null)
                  TextSpan(
                    text:
                        '${audioLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.audioLanguage} - ${activity.audioCodec?.toUpperCase()} ${StringHelper.capitalize(activity.audioChannelLayout!.split("(")[0])}',
                  ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: icon,
                  ),
                ),
                if (activity.streamAudioChannelLayout != null)
                  TextSpan(
                    text:
                        '${activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(activity.streamAudioChannelLayout!.split("(")[0])}',
                  ),
              ],
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      );
    } else if (activity.streamAudioDecision == StreamDecision.copy) {
      if (activity.streamAudioChannelLayout != null) {
        return Text(
          '${audioLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.audioLanguage} - ${LocaleKeys.direct_stream_title.tr()} (${activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(activity.streamAudioChannelLayout!.split("(")[0])})',
        );
      }
    } else {
      if (activity.streamAudioChannelLayout != null) {
        return Text(
          '${audioLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.audioLanguage} - ${LocaleKeys.direct_play_title.tr()} (${activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(activity.streamAudioChannelLayout!.split("(")[0])})',
        );
      }
    }

    return const Text('');
  }
}

class ActivityStreamSubtitleItem extends StatelessWidget {
  final ActivityModel activity;
  final Widget icon;
  final Color textColor;

  const ActivityStreamSubtitleItem({
    super.key,
    required this.activity,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (activity.subtitles == true) {
      final bool subtitleLanguageEmpty = isEmpty(activity.subtitleLanguage);

      if (activity.streamSubtitleDecision == SubtitleDecision.transcode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(LocaleKeys.transcode_title).tr(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.subtitleLanguage} - ${activity.subtitleCodec?.toUpperCase()}',
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: icon,
                    ),
                  ),
                  TextSpan(
                    text: activity.streamSubtitleCodec?.toUpperCase(),
                  ),
                ],
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      } else if (activity.streamSubtitleDecision == SubtitleDecision.copy) {
        return Text(
          '${LocaleKeys.direct_stream_title.tr()} (${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.subtitleLanguage} - ${activity.subtitleCodec?.toUpperCase()})',
        );
      } else if (activity.streamSubtitleDecision == SubtitleDecision.burn) {
        return Text(
          '${LocaleKeys.burn_title.tr()} (${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.subtitleLanguage} - ${activity.subtitleCodec?.toUpperCase()})',
        );
      } else {
        return Text(
          '${LocaleKeys.direct_play_title.tr()} (${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : activity.subtitleLanguage} - ${activity.streamSubtitleCodec?.toUpperCase()})',
        );
      }
    } else {
      return const Text(LocaleKeys.none_title).tr();
    }
  }
}
