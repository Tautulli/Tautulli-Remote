import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/data_unit_helper.dart';
import '../../../../../core/helpers/ip_address_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../geo_ip/data/models/geo_ip_model.dart';
import '../../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import 'activity_stream_details.dart';

class ActivityDetailsPageDetails extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;
  final Widget arrowIcon;
  final Color iconColor;
  final Color titleColor;
  final Widget lockIcon;
  final Widget loadingIndicator;

  const ActivityDetailsPageDetails({
    super.key,
    required this.server,
    required this.activity,
    required this.arrowIcon,
    required this.iconColor,
    required this.titleColor,
    required this.lockIcon,
    required this.loadingIndicator,
  });

  @override
  State<ActivityDetailsPageDetails> createState() => _ActivityDetailsPageDetailsState();
}

class _ActivityDetailsPageDetailsState extends State<ActivityDetailsPageDetails> {
  @override
  void initState() {
    super.initState();

    if (widget.activity.ipAddress != null) {
      context.read<GeoIpBloc>().add(
        GeoIpFetched(server: widget.server, ipAddress: widget.activity.ipAddress!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              _ItemRow(
                title: LocaleKeys.user_title.tr(),
                item: Text(widget.activity.friendlyName ?? '').sensitive(),
                titleColor: widget.titleColor,
              ),
              if (widget.activity.live != true &&
                  widget.activity.duration != null &&
                  widget.activity.viewOffset != null)
                _ItemRow(
                  title: LocaleKeys.eta_title.tr(),
                  item: Text(
                    TimeHelper.eta(
                      widget.activity.duration!,
                      widget.activity.progressPercent,
                      settingsState.appSettings.activeServer.timeFormat,
                    ),
                  ),
                  titleColor: widget.titleColor,
                ),
              const Gap(8),
              _ItemRow(
                title: LocaleKeys.product_title.tr(),
                item: Text(widget.activity.product ?? ''),
                titleColor: widget.titleColor,
              ),
              _ItemRow(
                title: LocaleKeys.player_title.tr(),
                item: Text(widget.activity.player ?? '').sensitive(),
                titleColor: widget.titleColor,
              ),
              _ItemRow(
                title: LocaleKeys.quality_title.tr(),
                item: Text(activityQualityText(widget.activity)),
                titleColor: widget.titleColor,
              ),
              if (widget.activity.optimizedVersion == true)
                _ItemRow(
                  title: LocaleKeys.optimized_title.tr(),
                  item: Text(
                    '${widget.activity.optimizedVersionProfile} ${widget.activity.optimizedVersionTitle}',
                  ),
                  titleColor: widget.titleColor,
                ),
              const Gap(8),
              _ItemRow(
                title: LocaleKeys.stream_title.tr(),
                item: Text(activityStreamDecisionText(widget.activity)),
                titleColor: widget.titleColor,
              ),
              _ItemRow(
                title: LocaleKeys.container_title.tr(),
                item: ActivityStreamContainerItem(
                  activity: widget.activity,
                  icon: widget.arrowIcon,
                  textColor: widget.iconColor,
                ),
                titleColor: widget.titleColor,
              ),
              if (widget.activity.mediaType != MediaType.track)
                _ItemRow(
                  title: LocaleKeys.video_title.tr(),
                  item: ActivityStreamVideoItem(
                    activity: widget.activity,
                    icon: widget.arrowIcon,
                    textColor: widget.iconColor,
                  ),
                  titleColor: widget.titleColor,
                ),
              if (widget.activity.mediaType != MediaType.photo)
                _ItemRow(
                  title: LocaleKeys.audio_title.tr(),
                  item: ActivityStreamAudioItem(
                    activity: widget.activity,
                    icon: widget.arrowIcon,
                    textColor: widget.iconColor,
                  ),
                  titleColor: widget.titleColor,
                ),
              if (![MediaType.track, MediaType.photo].contains(widget.activity.mediaType))
                _ItemRow(
                  title: LocaleKeys.subtitle_title.tr(),
                  item: ActivityStreamSubtitleItem(
                    activity: widget.activity,
                    icon: widget.arrowIcon,
                    textColor: widget.iconColor,
                  ),
                  titleColor: widget.titleColor,
                ),
              const Gap(8),
              _ItemRow(
                title: LocaleKeys.ip_address_title.tr(),
                item: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: widget.lockIcon,
                    ),
                    Expanded(
                      child: Text(
                        '${widget.activity.location?.apiValue().toUpperCase()}: ${widget.activity.ipAddress}',
                      ).sensitive(),
                    ),
                  ],
                ),
                titleColor: widget.titleColor,
              ),
              if (widget.activity.ipAddress != null && IpAddressHelper.isPublic(widget.activity.ipAddress!))
                _ItemRow(
                  title: LocaleKeys.location_title.tr(),
                  item: BlocBuilder<GeoIpBloc, GeoIpState>(
                    builder: (context, geoIpState) {
                      final GeoIpModel? geoIpItem = geoIpState.geoIpMap[widget.activity.ipAddress];
                      final String? city = geoIpItem?.city;
                      final String? region = geoIpItem?.region;
                      final String? code = geoIpItem?.code;

                      if (widget.activity.relay == true) {
                        return const Text(LocaleKeys.plex_relay_message).tr();
                      } else if (geoIpState.status == BlocStatus.success) {
                        return Text('$city, $region $code').sensitive();
                      } else if (geoIpState.status == BlocStatus.failure) {
                        return const Text(LocaleKeys.location_lookup_failed_message).tr();
                      } else {
                        return widget.loadingIndicator;
                      }
                    },
                  ),
                  titleColor: widget.titleColor,
                ),
              _ItemRow(
                title: LocaleKeys.bandwidth_title.tr(),
                item: widget.activity.mediaType != MediaType.photo
                    ? Text(DataUnitHelper.bitrate(widget.activity.bandwidth ?? 0))
                    : const Text(LocaleKeys.unknown_title).tr(),
                titleColor: widget.titleColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final Widget item;
  final Color titleColor;

  const _ItemRow({
    required this.title,
    required this.item,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: titleColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const Gap(8),
          Expanded(child: item),
        ],
      ),
    );
  }
}
