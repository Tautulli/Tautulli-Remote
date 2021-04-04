import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../features/activity/domain/entities/activity.dart';
import 'color_palette_helper.dart';
import 'string_format_helper.dart';

/// Various helper functions to return [RichText] data for activity data.
class ActivityMediaDetailsCleaner {
  static List<List> audio(ActivityItem activity) {
    const String title = 'AUDIO';
    List<List> list = [];

    if (activity.streamAudioDecision != '') {
      if (activity.streamAudioDecision == 'transcode') {
        list.add([
          title,
          RichText(
            text: const TextSpan(
              text: 'Transcode',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ]);

        String textLeft =
            '${activity.audioCodec.toUpperCase()} ${StringFormatHelper.capitalize(activity.audioChannelLayout.split("(")[0])}';
        String textRight =
            '${activity.streamAudioCodec.toUpperCase()} ${StringFormatHelper.capitalize(activity.streamAudioChannelLayout.split("(")[0])}';

        list.add([
          '',
          _formatValue(left: textLeft, right: textRight),
        ]);
      } else if (activity.streamAudioDecision == 'copy') {
        String textLeft =
            'Direct Stream (${activity.streamAudioCodec.toUpperCase()} ${StringFormatHelper.capitalize(activity.streamAudioChannelLayout.split("(")[0])})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else {
        String textLeft =
            'Direct Play (${activity.streamAudioCodec.toUpperCase()} ${StringFormatHelper.capitalize(activity.streamAudioChannelLayout.split("(")[0])})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      }
    }
    return list;
  }

  static List<List> bandwidth(ActivityItem activity) {
    String finalText;

    if (activity.mediaType != 'photo' &&
        !['Unknown', '', ' '].contains(activity.bandwidth)) {
      int _bw = int.parse(activity.bandwidth);
      if (_bw > 1000000) {
        finalText = '${(_bw / 1000000).toStringAsFixed(1)} Gbps';
      } else if (_bw > 1000) {
        finalText = '${(_bw / 1000).toStringAsFixed(1)} Mbps';
      } else {
        finalText = '$_bw kbps';
      }
    } else if (activity.syncedVersion == 1) {
      finalText = 'None';
    } else {
      finalText = 'Unknown';
    }
    final formattedBandwidth = RichText(
      text: TextSpan(
        text: finalText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      ['BANDWIDTH', formattedBandwidth]
    ];
  }

  static List<List> container(ActivityItem activity) {
    String title = 'CONTAINER';
    List<List> list = [];

    if (activity.streamContainerDecision == 'transcode') {
      list.add([
        title,
        RichText(
          text: const TextSpan(
            text: 'Converting',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ]);

      String leftText = '${activity.container.toUpperCase()}';
      String rightText = '${activity.streamContainer.toUpperCase()}';

      list.add(['', _formatValue(left: leftText, right: rightText)]);
    } else {
      String value = 'Direct Play (${activity.streamContainer.toUpperCase()})';
      list.add([title, _formatValue(left: value)]);
    }

    return list;
  }

  static List<List> location(
    ActivityItem activity,
    bool maskSensitiveInfo,
  ) {
    String text;
    IconData icon;

    if (activity.ipAddress != 'N/A') {
      if (activity.secure == 1) {
        icon = FontAwesomeIcons.lock;
      } else {
        icon = FontAwesomeIcons.unlock;
      }
      text =
          '${activity.location.toUpperCase()}: ${maskSensitiveInfo ? '*Hidden IP Address*' : activity.ipAddress}';
    } else {
      text = 'N/A';
    }

    final formattedLocation = RichText(
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.only(
                  right: 5,
                ),
                child: FaIcon(
                  icon,
                  color: TautulliColorPalette.not_white,
                  size: 16.5,
                ),
              ),
            ),
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    return [
      ['LOCATION', formattedLocation]
    ];
  }

  static List<List> locationDetails({
    @required String type,
    String city,
    String region,
    String code,
    bool maskSensitiveInfo,
  }) {
    if (city != null && city != 'Unknown') {
      city = '$city, ';
    } else {
      city = '';
    }
    if (region == null) {
      region = '';
    }
    if (code == null) {
      code = '';
    }

    final formattedLocationDetails = RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: FaIcon(
                type == 'relay'
                    ? FontAwesomeIcons.exclamationCircle
                    : FontAwesomeIcons.mapMarkerAlt,
                color: TautulliColorPalette.not_white,
                size: 16.5,
              ),
            ),
          ),
          TextSpan(
            text: type == 'relay'
                ? 'This stream is using Plex Relay'
                : maskSensitiveInfo
                    ? '*Hidden Location*'
                    : '$city$region $code',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    return [
      ['', formattedLocationDetails]
    ];
  }

  static List<List> optimized(ActivityItem activity) {
    final formattedOptimized = RichText(
      text: TextSpan(
        text:
            '${activity.optimizedVersionProfile} ${activity.optimizedVersionTitle}',
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      ['OPTIMIZED', formattedOptimized]
    ];
  }

  static List<List> player(ActivityItem activity) {
    final formattedPlayer = RichText(
      text: TextSpan(
        text: activity.player,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      ['PLAYER', formattedPlayer]
    ];
  }

  static List<List> product(ActivityItem activity) {
    final formattedProduct = RichText(
      text: TextSpan(
        text: activity.product,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
    return [
      ['PRODUCT', formattedProduct]
    ];
  }

  static List<List> quality(ActivityItem activity) {
    String formattedBitrate;
    String finalText;

    if (activity.mediaType != 'photo' && activity.qualityProfile != 'Unknown') {
      if (activity.streamBitrate > 1000) {
        formattedBitrate =
            '${(activity.streamBitrate / 1000).toStringAsFixed(1)} Mbps';
      } else {
        formattedBitrate = '${activity.streamBitrate} kbps';
      }
    }

    if (isNotBlank(formattedBitrate)) {
      finalText = '${activity.qualityProfile} ($formattedBitrate)';
    } else {
      finalText = activity.qualityProfile;
    }

    final formattedQuality = RichText(
      text: TextSpan(
        text: finalText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      ['QUALITY', formattedQuality]
    ];
  }

  static List<List> stream(ActivityItem activity) {
    String finalText;

    if (activity.transcodeDecision == 'transcode') {
      if (activity.transcodeThrottled == 1) {
        finalText = 'Transcode (Throttled)';
      } else {
        finalText = 'Transcode (Speed: ${activity.transcodeSpeed})';
      }
    } else if (activity.transcodeDecision == 'copy') {
      finalText = 'Direct Stream';
    } else {
      finalText = 'Direct Play';
    }
    final formattedStream = RichText(
      text: TextSpan(
        text: finalText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      ['STREAM', formattedStream]
    ];
  }

  static List<List> subtitles(ActivityItem activity) {
    const String title = 'SUBTITLE';
    List<List> list = [];

    if (activity.subtitles == 1) {
      if (activity.streamSubtitleDecision == 'transcode') {
        list.add([
          title,
          RichText(
            text: const TextSpan(
              text: 'Transcode',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ]);

        String textLeft = '${activity.subtitleCodec.toUpperCase()}';
        String textRight = '${activity.streamSubtitleCodec.toUpperCase()}';

        list.add([
          '',
          _formatValue(left: textLeft, right: textRight),
        ]);
      } else if (activity.streamSubtitleDecision == 'copy') {
        String textLeft =
            'Direct Stream (${activity.subtitleCodec.toUpperCase()})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else if (activity.streamSubtitleDecision == 'burn') {
        String textLeft = 'Burn (${activity.subtitleCodec.toUpperCase()})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else {
        if (activity.syncedVersion == 1) {
          String textLeft =
              'Direct Play (${activity.subtitleCodec.toUpperCase()})';

          list.add([
            title,
            _formatValue(left: textLeft),
          ]);
        } else {
          String textLeft =
              'Direct Play (${activity.streamSubtitleCodec.toUpperCase()})';

          list.add([
            title,
            _formatValue(left: textLeft),
          ]);
        }
      }
    } else {
      String textLeft = 'None';

      list.add([
        title,
        _formatValue(left: textLeft),
      ]);
    }
    return list;
  }

  static List<List> synced(ActivityItem activity) {
    final formattedSynced = RichText(
      text: TextSpan(
        text: activity.syncedVersionProfile,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      ['SYNCED', formattedSynced]
    ];
  }

  static List<List> video(ActivityItem activity) {
    const String title = 'VIDEO';
    List<List> list = [];

    String _videoDynamicRange = '';
    String _streamVideoDynamicRange = '';
    String _hwD = '';
    String _hwE = '';

    if (['movie', 'episode', 'clip', 'photo'].contains(activity.mediaType) &&
        isNotBlank(activity.streamVideoDecision)) {
      if (activity.videoDynamicRange == 'HDR') {
        _videoDynamicRange = ' ${activity.videoDynamicRange}';
        _streamVideoDynamicRange = ' ${activity.streamVideoDynamicRange}';
      }
      if (activity.streamVideoDecision == 'transcode') {
        if (activity.transcodeHwDecoding == 1) {
          _hwD = ' (HW)';
        }
        if (activity.transcodeHwEncoding == 1) {
          _hwE = ' (HW)';
        }
        list.add([
          title,
          RichText(
            text: const TextSpan(
              text: 'Transcode',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ]);

        String textLeft =
            '${activity.videoCodec.toUpperCase()}$_hwD ${activity.videoFullResolution}$_videoDynamicRange';
        String textRight =
            '${activity.streamVideoCodec.toUpperCase()}$_hwE ${activity.streamVideoFullResolution}$_streamVideoDynamicRange';

        list.add([
          '',
          _formatValue(
            left: textLeft,
            right: textRight,
          ),
        ]);
      } else if (activity.streamVideoDecision == 'copy') {
        String textLeft =
            'Direct Stream (${activity.streamVideoCodec.toUpperCase()} ${activity.streamVideoFullResolution}$_streamVideoDynamicRange)';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else {
        String textLeft =
            'Direct Play (${activity.streamVideoCodec.toUpperCase()} ${activity.streamVideoFullResolution}$_streamVideoDynamicRange)';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      }
    } else if (activity.mediaType == 'photo') {
      String textLeft = 'Direct Play (${activity.width}x${activity.height})';

      list.add([
        title,
        _formatValue(left: textLeft),
      ]);
    }

    return list;
  }
}

class MediaFlagsCleaner {
  static String audioChannels(String flag) {
    switch (flag) {
      case '1':
        return 'Mono';
      case '2':
        return 'Stereo';
      case '3':
        return '2.1';
      case '4':
        return '3.1';
      case '6':
        return '5.1';
      case '7':
        return '6.1';
      case '8':
        return '7.1';
      default:
        return flag;
    }
  }
}

RichText _formatValue({
  final String left,
  final String right,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: left,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        if (isNotBlank(right))
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: const FaIcon(
                FontAwesomeIcons.longArrowAltRight,
                color: TautulliColorPalette.not_white,
                size: 16.5,
              ),
            ),
          ),
        if (isNotBlank(right))
          TextSpan(
            text: right,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
      ],
    ),
  );
}
