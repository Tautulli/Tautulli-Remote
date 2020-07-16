import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import 'string_format_helper.dart';
/// Various helper functions to return [RichText] widgetsfor activity data.
abstract class ActivityMediaDetailsCleaner {
  RichText product({
    @required String product,
  });
  RichText player({
    @required String platformName,
  });
  RichText quality({
    @required String mediaType,
    @required String qualityProfile,
    @required int streamBitrate,
  });
  RichText optimized({
    @required String optimizedVersionProfile,
    @required String optimizedVersionTitle,
  });
  RichText synced({
    @required String syncedVersionProfile,
  });
  RichText stream({
    @required String transcodeDecision,
    @required int transcodeThrottled,
    @required double transcodeSpeed,
  });
  RichText container({
    @required String streamContainerDecision,
    @required String container,
    @required String streamContainer,
  });
  RichText video({
    @required String mediaType,
    @required String streamVideoDecision,
    @required String videoDynamicRange,
    @required String streamVideoDynamicRange,
    @required int transcodeHwDecoding,
    @required int transcodeHwEncoding,
    @required String videoCodec,
    @required String videoFullResolution,
    @required String streamVideoCodec,
    @required String streamVideoFullResolution,
    @required int width,
    @required int height,
  });
  RichText audio({
    @required String streamAudioDecision,
    @required String audioCodec,
    @required String audioChannelLayout,
    @required String streamAudioCodec,
    @required String streamAudioChannelLayout,
  });
  RichText subtitles({
    @required int subtitles,
    @required String streamSubtitleDecision,
    @required String subtitleCodec,
    @required String streamSubtitleCodec,
    @required int syncedVersion,
  });
  RichText location({
    @required int secure,
    @required String location,
    @required String ipAddress,
    @required int relayed,
  });
  RichText locationDetails({
    @required String type,
  });
  RichText bandwidth({
    @required String mediaType,
    @required String bandwidth,
    @required int syncedVersion,
  });
}

class ActivityMediaDetailsCleanerImpl implements ActivityMediaDetailsCleaner {
  @override
  RichText audio({
    @required String streamAudioDecision,
    @required String audioCodec,
    @required String audioChannelLayout,
    @required String streamAudioCodec,
    @required String streamAudioChannelLayout,
  }) {
    String finalTextLeft;
    String finalTextRight;

    if (streamAudioDecision != '') {
      if (streamAudioDecision == 'transcode') {
        finalTextLeft =
            'Transcode (${audioCodec.toUpperCase()} ${StringFormatHelper.capitalize(audioChannelLayout.split("(")[0])}';
        finalTextRight =
            '${streamAudioCodec.toUpperCase()} ${StringFormatHelper.capitalize(streamAudioChannelLayout.split("(")[0])})';
      } else if (streamAudioDecision == 'copy') {
        finalTextLeft =
            'Direct Stream (${streamAudioCodec.toUpperCase()} ${StringFormatHelper.capitalize(streamAudioChannelLayout.split("(")[0])})';
      } else {
        finalTextLeft =
            'Direct Play (${streamAudioCodec.toUpperCase()} ${StringFormatHelper.capitalize(streamAudioChannelLayout.split("(")[0])})';
      }
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: finalTextLeft,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          if (isNotBlank(finalTextRight))
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: FaIcon(
                  FontAwesomeIcons.longArrowAltRight,
                  color: Colors.white,
                  size: 16.5,
                ),
              ),
            ),
          if (isNotBlank(finalTextRight))
            TextSpan(
              text: finalTextRight,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  @override
  RichText bandwidth({
    @required String mediaType,
    @required String bandwidth,
    @required int syncedVersion,
  }) {
    String finalText;

    if (mediaType != 'photo' && bandwidth != 'Unknown' && bandwidth != '') {
      int _bw = int.parse(bandwidth);
      if (_bw > 1000000) {
        finalText = '${(_bw / 1000000).toStringAsFixed(1)} Gbps';
      } else if (_bw > 1000) {
        finalText = '${(_bw / 1000).toStringAsFixed(1)} Mbps';
      } else {
        finalText = '$_bw kbps';
      }
    } else if (syncedVersion == 1) {
      finalText = 'None';
    } else if (bandwidth == '') {
      finalText = '0 kbps';
    } else {
      finalText = 'Unknown';
    }
    return RichText(
      text: TextSpan(
        text: finalText,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText container({
    @required String streamContainerDecision,
    @required String container,
    @required String streamContainer,
  }) {
    String finalTextLeft;
    String finalTextRight;

    if (streamContainerDecision == 'transcode') {
      finalTextLeft = 'Transcode (${container.toUpperCase()}';
      finalTextRight = '${streamContainer.toUpperCase()})';
    } else {
      finalTextLeft = 'Direct Play (${streamContainer.toUpperCase()})';
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: finalTextLeft,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          if (isNotBlank(finalTextRight))
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: FaIcon(
                  FontAwesomeIcons.longArrowAltRight,
                  color: Colors.white,
                  size: 16.5,
                ),
              ),
            ),
          if (isNotBlank(finalTextRight))
            TextSpan(
              text: finalTextRight,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  @override
  RichText location({
    @required int secure,
    @required String location,
    @required String ipAddress,
    @required int relayed,
  }) {
    IconData icon;
    String finalText;

    if (ipAddress != 'N/A') {
      if (secure == 1) {
        icon = FontAwesomeIcons.lock;
      } else {
        icon = FontAwesomeIcons.unlock;
      }
      finalText = '${location.toUpperCase()}: $ipAddress';
    } else {
      finalText = 'N/A';
    }
    return RichText(
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: FaIcon(
                  icon,
                  color: Colors.white,
                  size: 16.5,
                ),
              ),
            ),
          TextSpan(
            text: finalText,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  RichText locationDetails({
    @required String type,
    String city,
    String region,
    String code,
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

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: FaIcon(
                type == 'relay'
                    ? FontAwesomeIcons.exclamationCircle
                    : FontAwesomeIcons.mapMarkerAlt,
                color: Colors.white,
                size: 16.5,
              ),
            ),
          ),
          TextSpan(
            text: type == 'relay'
                ? 'This stream is using Plex Relay'
                : '$city$region $code',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  RichText optimized({
    @required String optimizedVersionProfile,
    @required String optimizedVersionTitle,
  }) {
    return RichText(
      text: TextSpan(
        text: '$optimizedVersionProfile $optimizedVersionTitle',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText player({
    @required String platformName,
  }) {
    return RichText(
      text: TextSpan(
        text: StringFormatHelper.capitalize(platformName),
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText product({
    @required String product,
  }) {
    return RichText(
      text: TextSpan(
        text: product,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText quality({
    @required String mediaType,
    @required String qualityProfile,
    @required int streamBitrate,
  }) {
    String formattedBitrate;
    String finalText;

    if (mediaType != 'photo' && qualityProfile != 'Unknown') {
      if (streamBitrate > 1000) {
        formattedBitrate =
            '${(streamBitrate / 1000).toStringAsFixed(1)} Mbps';
      } else {
        formattedBitrate = '$streamBitrate kbps';
      }
    }

    if (isNotBlank(formattedBitrate)) {
      finalText = '$qualityProfile ($formattedBitrate)';
    } else {
      finalText = qualityProfile;
    }

    return RichText(
      text: TextSpan(
        text: finalText,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText stream({
    @required String transcodeDecision,
    @required int transcodeThrottled,
    @required double transcodeSpeed,
  }) {
    String finalText;

    if (transcodeDecision == 'transcode') {
      if (transcodeThrottled == 1) {
        finalText = 'Transcode (Throttled)';
      } else {
        finalText = 'Transcode (Speed: $transcodeSpeed)';
      }
    } else if (transcodeDecision == 'copy') {
      finalText = 'Direct Stream';
    } else {
      finalText = 'Direct Play';
    }
    return RichText(
      text: TextSpan(
        text: finalText,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText subtitles({
    @required int subtitles,
    @required String streamSubtitleDecision,
    @required String subtitleCodec,
    @required String streamSubtitleCodec,
    @required int syncedVersion,
  }) {
    String finalTextLeft;
    String finalTextRight;

    if (subtitles == 1) {
      if (streamSubtitleDecision == 'transcode') {
        finalTextLeft = 'Transcode (${subtitleCodec.toUpperCase()}';
        finalTextRight = '${streamSubtitleCodec.toUpperCase()})';
      } else if (streamSubtitleDecision == 'copy') {
        finalTextLeft = 'Direct Stream (${subtitleCodec.toUpperCase()})';
      } else if (streamSubtitleDecision == 'burn') {
        finalTextLeft = 'Burn (${subtitleCodec.toUpperCase()})';
      } else {
        if (syncedVersion == 1) {
          finalTextLeft = 'Direct Play (${subtitleCodec.toUpperCase()})';
        } else {
          finalTextLeft = 'Direct Play (${streamSubtitleCodec.toUpperCase()})';
        }
      }
    } else {
      finalTextLeft = 'None';
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: finalTextLeft,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          if (isNotBlank(finalTextRight))
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: FaIcon(
                  FontAwesomeIcons.longArrowAltRight,
                  color: Colors.white,
                  size: 16.5,
                ),
              ),
            ),
          if (isNotBlank(finalTextRight))
            TextSpan(
              text: finalTextRight,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  @override
  RichText synced({
    @required String syncedVersionProfile,
  }) {
    return RichText(
      text: TextSpan(
        text: syncedVersionProfile,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  RichText video({
    @required String mediaType,
    @required String streamVideoDecision,
    @required String videoDynamicRange,
    @required String streamVideoDynamicRange,
    @required int transcodeHwDecoding,
    @required int transcodeHwEncoding,
    @required String videoCodec,
    @required String videoFullResolution,
    @required String streamVideoCodec,
    @required String streamVideoFullResolution,
    @required int width,
    @required int height,
  }) {
    String _videoDynamicRange = '';
    String _streamVideoDynamicRange = '';
    String _hwD = '';
    String _hwE = '';
    String finalTextLeft;
    String finalTextRight;

    if (['movie', 'episode', 'clip', 'photo'].contains(mediaType) &&
        isNotBlank(streamVideoDecision)) {
      if (videoDynamicRange == 'HDR') {
        _videoDynamicRange = ' $videoDynamicRange';
        _streamVideoDynamicRange = ' $streamVideoDynamicRange';
      }
      if (streamVideoDecision == 'transcode') {
        if (transcodeHwDecoding == 1) {
          _hwD = ' (HW)';
        }
        if (transcodeHwEncoding == 1) {
          _hwE = ' (HW)';
        }
        finalTextLeft =
            'Transcode (${videoCodec.toUpperCase()}$_hwD $videoFullResolution$_videoDynamicRange';
        finalTextRight =
            '${streamVideoCodec.toUpperCase()}$_hwE $streamVideoFullResolution$_streamVideoDynamicRange)';
      } else if (streamVideoDecision == 'copy') {
        finalTextLeft =
            'Direct Stream (${streamVideoCodec.toUpperCase()} $streamVideoFullResolution$_streamVideoDynamicRange)';
      } else {
        finalTextLeft =
            'Direct Play (${streamVideoCodec.toUpperCase()} $streamVideoFullResolution$_streamVideoDynamicRange)';
      }
    } else if (mediaType == 'photo') {
      finalTextLeft = 'Direct Play (${width}x$height)';
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: finalTextLeft,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          if (isNotBlank(finalTextRight))
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: FaIcon(
                  FontAwesomeIcons.longArrowAltRight,
                  color: Colors.white,
                  size: 16.5,
                ),
              ),
            ),
          if (isNotBlank(finalTextRight))
            TextSpan(
              text: finalTextRight,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}
