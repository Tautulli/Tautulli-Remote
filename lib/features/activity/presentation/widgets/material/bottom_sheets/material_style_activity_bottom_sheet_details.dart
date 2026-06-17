import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/helpers/data_unit_helper.dart';
import '../../../../../../core/helpers/ip_address_helper.dart';
import '../../../../../../core/types/bloc_status.dart';
import '../../../../../../core/types/tautulli_types.dart';
import '../../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../geo_ip/data/models/geo_ip_model.dart';
import '../../../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../data/models/activity_model.dart';
import '../../base/activity_stream_details.dart';

class MaterialStyleActivityBottomSheetDetails extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const MaterialStyleActivityBottomSheetDetails({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<MaterialStyleActivityBottomSheetDetails> createState() => _MaterialStyleActivityBottomSheetDetailsState();
}

class _MaterialStyleActivityBottomSheetDetailsState extends State<MaterialStyleActivityBottomSheetDetails> {
  @override
  void initState() {
    super.initState();

    if (widget.activity.ipAddress != null) {
      context.read<GeoIpBloc>().add(
        GeoIpFetched(
          server: widget.server,
          ipAddress: widget.activity.ipAddress!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            settingsState as SettingsSuccess;

            final textColor = Theme.of(context).colorScheme.onSurface;
            final icon = FaIcon(FontAwesomeIcons.rightLong, size: 16, color: textColor);

            return Column(
              children: [
                _ItemRow(
                  title: LocaleKeys.product_title.tr(),
                  item: Text(
                    widget.activity.product ?? '',
                  ),
                ),
                _ItemRow(
                  title: LocaleKeys.player_title.tr(),
                  item: Text(widget.activity.player ?? '').sensitive(),
                ),
                _ItemRow(
                  title: LocaleKeys.quality_title.tr(),
                  item: Text(activityQualityText(widget.activity)),
                ),
                if (widget.activity.optimizedVersion == true)
                  _ItemRow(
                    title: LocaleKeys.optimized_title.tr(),
                    item: Text(
                      '${widget.activity.optimizedVersionProfile} ${widget.activity.optimizedVersionTitle}',
                    ),
                  ),
                //TODO: Add a section for downloads if that ever gets supported
                const Gap(8),
                _ItemRow(
                  title: LocaleKeys.stream_title.tr(),
                  item: Text(activityStreamDecisionText(widget.activity)),
                ),
                _ItemRow(
                  title: LocaleKeys.container_title.tr(),
                  item: ActivityStreamContainerItem(
                    activity: widget.activity,
                    icon: icon,
                    textColor: textColor,
                  ),
                ),
                if (widget.activity.mediaType != MediaType.track)
                  _ItemRow(
                    title: LocaleKeys.video_title.tr(),
                    item: ActivityStreamVideoItem(
                      activity: widget.activity,
                      icon: icon,
                      textColor: textColor,
                    ),
                  ),
                if (widget.activity.mediaType != MediaType.photo)
                  _ItemRow(
                    title: LocaleKeys.audio_title.tr(),
                    item: ActivityStreamAudioItem(
                      activity: widget.activity,
                      icon: icon,
                      textColor: textColor,
                    ),
                  ),
                if (![MediaType.track, MediaType.photo].contains(widget.activity.mediaType))
                  _ItemRow(
                    title: LocaleKeys.subtitle_title.tr(),
                    item: ActivityStreamSubtitleItem(
                      activity: widget.activity,
                      icon: icon,
                      textColor: textColor,
                    ),
                  ),
                const Gap(8),
                _ItemRow(
                  title: LocaleKeys.ip_address_title.tr(),
                  item: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: FaIcon(
                          widget.activity.secure == true ? FontAwesomeIcons.lock : FontAwesomeIcons.lockOpen,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${widget.activity.location?.apiValue().toUpperCase()}: ${widget.activity.ipAddress}',
                        ).sensitive(),
                      ),
                    ],
                  ),
                ),
                if (widget.activity.ipAddress != null && IpAddressHelper.isPublic(widget.activity.ipAddress!))
                  _ItemRow(
                    title: LocaleKeys.location_title.tr(),
                    item: BlocBuilder<GeoIpBloc, GeoIpState>(
                      builder: (context, geoIpState) {
                        GeoIpModel? geoIpItem = geoIpState.geoIpMap[widget.activity.ipAddress];
                        String? city = geoIpItem?.city;
                        String? region = geoIpItem?.region;
                        String? code = geoIpItem?.code;

                        if (widget.activity.relay == true) {
                          return const Text(LocaleKeys.plex_relay_message).tr();
                        } else if (geoIpState.status == BlocStatus.success) {
                          return Text('$city, $region $code').sensitive();
                        } else if (geoIpState.status == BlocStatus.failure) {
                          return const Text(
                            LocaleKeys.location_lookup_failed_message,
                          ).tr();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            child: SizedBox(
                              width: 130,
                              child: LinearProgressIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                _ItemRow(
                  title: LocaleKeys.bandwidth_title.tr(),
                  item: Builder(
                    builder: (context) {
                      if (widget.activity.mediaType != MediaType.photo) {
                        return Text(
                          DataUnitHelper.bitrate(
                            widget.activity.bandwidth ?? 0,
                          ),
                        );
                      }

                      return const Text(LocaleKeys.unknown_title).tr();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final Widget item;

  const _ItemRow({
    required this.title,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
