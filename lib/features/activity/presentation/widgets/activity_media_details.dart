import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/geo_ip.dart';

import '../../../../core/helpers/clean_data_helper.dart';
import '../../domain/entities/activity.dart';

class ActivityMediaDetails extends StatelessWidget {
  final BoxConstraints constraints;
  final ActivityItem activity;
  final GeoIpItem geoIp;

  const ActivityMediaDetails({
    Key key,
    @required this.constraints,
    @required this.activity,
    @required this.geoIp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cleanDetails = ActivityMediaDetailsCleanerImpl();

    return ListView(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: "PRODUCT",
          textSpan: cleanDetails.product(
            product: activity.product,
          ),
        ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: "PLAYER",
          textSpan: cleanDetails.player(
            platformName: activity.platformName,
          ),
        ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: "QUALITY",
          textSpan: cleanDetails.quality(
            mediaType: activity.mediaType,
            qualityProfile: activity.qualityProfile,
            streamBitrate: activity.streamBitrate,
          ),
        ),
        if (activity.optimizedVersion == 1)
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: "OPTIMIZED",
            textSpan: cleanDetails.optimized(
              optimizedVersionProfile: activity.optimizedVersionProfile,
              optimizedVersionTitle: activity.optimizedVersionTitle,
            ),
          ),
        if (activity.syncedVersion == 1)
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: 'SYNCED',
            textSpan: cleanDetails.synced(
                syncedVersionProfile: activity.syncedVersionProfile),
          ),
        SizedBox(
          height: 15,
        ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: 'STREAM',
          textSpan: cleanDetails.stream(
            transcodeDecision: activity.transcodeDecision,
            transcodeSpeed: activity.transcodeSpeed,
            transcodeThrottled: activity.transcodeThrottled,
          ),
        ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: 'CONTAINER',
          textSpan: cleanDetails.container(
            container: activity.container,
            streamContainer: activity.streamContainer,
            streamContainerDecision: activity.streamContainerDecision,
          ),
        ),
        if (activity.mediaType != 'track')
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: 'VIDEO',
            textSpan: cleanDetails.video(
              height: activity.height,
              mediaType: activity.mediaType,
              streamVideoCodec: activity.streamVideoCodec,
              streamVideoDecision: activity.streamVideoDecision,
              streamVideoDynamicRange: activity.streamVideoDynamicRange,
              streamVideoFullResolution: activity.streamVideoFullResolution,
              transcodeHwDecoding: activity.transcodeHwDecoding,
              transcodeHwEncoding: activity.transcodeHwEncoding,
              videoCodec: activity.videoCodec,
              videoDynamicRange: activity.videoDynamicRange,
              videoFullResolution: activity.videoFullResolution,
              width: activity.width,
            ),
          ),
        if (activity.mediaType != 'photo')
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: 'AUDIO',
            textSpan: cleanDetails.audio(
              audioChannelLayout: activity.audioChannelLayout,
              audioCodec: activity.audioCodec,
              streamAudioChannelLayout: activity.streamAudioChannelLayout,
              streamAudioCodec: activity.streamAudioCodec,
              streamAudioDecision: activity.streamAudioDecision,
            ),
          ),
        if (activity.mediaType != 'track' && activity.mediaType != 'photo')
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: 'SUBTITLE',
            textSpan: cleanDetails.subtitles(
              streamSubtitleCodec: activity.streamSubtitleCodec,
              streamSubtitleDecision: activity.streamSubtitleDecision,
              subtitleCodec: activity.subtitleCodec,
              subtitles: activity.subtitles,
              syncedVersion: activity.syncedVersion,
            ),
          ),
        SizedBox(
          height: 15,
        ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: 'LOCATION',
          textSpan: cleanDetails.location(
            ipAddress: activity.ipAddress,
            location: activity.location,
            relayed: activity.relayed,
            secure: activity.secure,
          ),
        ),
        if (activity.relayed == 1)
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: '',
            textSpan: cleanDetails.locationDetails(
              type: 'relay',
            ),
          ),
        if (activity.relayed == 0 && geoIp != null && geoIp.code != 'ZZ')
          _rowBuilder(
            context: context,
            constraints: constraints,
            title: '',
            textSpan: cleanDetails.locationDetails(
              type: 'ip',
              city: geoIp.city,
              region: geoIp.region,
              code: geoIp.code,
            ),
          ),
        _rowBuilder(
          context: context,
          constraints: constraints,
          title: 'BANDWIDTH',
          textSpan: cleanDetails.bandwidth(
            bandwidth: activity.bandwidth,
            mediaType: activity.mediaType,
            syncedVersion: activity.syncedVersion,
          ),
        ),
      ],
    );
  }
}

Widget _rowBuilder({
  @required BuildContext context,
  @required BoxConstraints constraints,
  @required String title,
  @required RichText textSpan,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 5,
      right: 5,
      bottom: 5,
    ),
    child: Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                width: constraints.maxWidth / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(title),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      textSpan,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
