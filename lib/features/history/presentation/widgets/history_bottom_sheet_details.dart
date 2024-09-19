import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/ip_address_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../geo_ip/data/models/geo_ip_model.dart';
import '../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/history_model.dart';

class HistoryBottomSheetDetails extends StatefulWidget {
  final ServerModel server;
  final HistoryModel history;

  const HistoryBottomSheetDetails({
    super.key,
    required this.server,
    required this.history,
  });

  @override
  State<HistoryBottomSheetDetails> createState() => _HistoryBottomSheetDetailsState();
}

class _HistoryBottomSheetDetailsState extends State<HistoryBottomSheetDetails> {
  @override
  void initState() {
    super.initState();

    if (widget.history.ipAddress != null) {
      context.read<GeoIpBloc>().add(
            GeoIpFetched(
              server: widget.server,
              ipAddress: widget.history.ipAddress!,
              settingsBloc: context.read<SettingsBloc>(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  return Column(
                    children: [
                      _ItemRow(
                        title: LocaleKeys.user_title.tr(),
                        item: Text(
                          settingsState.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : widget.history.friendlyName ?? '',
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.platform_title.tr(),
                        item: Text(
                          widget.history.platform ?? '',
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.product_title.tr(),
                        item: Text(
                          widget.history.product ?? '',
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.player_title.tr(),
                        item: Text(
                          widget.history.player ?? '',
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.decision_title.tr(),
                        item: Text(
                          StringHelper.mapStreamDecisionToString(
                            widget.history.transcodeDecision,
                          ),
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.ip_address_title.tr(),
                        item: Text(
                          settingsState.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : widget.history.ipAddress ?? '',
                        ),
                      ),
                      if (widget.history.ipAddress != null && IpAddressHelper.isPublic(widget.history.ipAddress!))
                        _ItemRow(
                          title: LocaleKeys.location_title.tr(),
                          item: BlocBuilder<GeoIpBloc, GeoIpState>(
                            builder: (context, geoIpState) {
                              GeoIpModel? geoIpItem = geoIpState.geoIpMap[widget.history.ipAddress];
                              String? city = geoIpItem?.city;
                              String? region = geoIpItem?.region;
                              String? code = geoIpItem?.code;

                              if (settingsState.appSettings.maskSensitiveInfo) {
                                return Text(LocaleKeys.hidden_message.tr());
                              } else if (geoIpState.status == BlocStatus.success) {
                                return Text('$city, $region $code');
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
                      const Gap(8),
                      _ItemRow(
                        title: LocaleKeys.date_title.tr(),
                        item: Text(
                          TimeHelper.cleanDateTime(
                            widget.history.date!,
                            dateFormat: settingsState.appSettings.activeServer.dateFormat,
                            dateOnly: true,
                          ),
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.started_title.tr(),
                        item: Text(
                          TimeHelper.cleanDateTime(
                            widget.history.started!,
                            timeFormat: settingsState.appSettings.activeServer.timeFormat,
                            timeOnly: true,
                          ),
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.stopped_title.tr(),
                        item: Text(
                          TimeHelper.cleanDateTime(
                            widget.history.stopped!,
                            timeFormat: settingsState.appSettings.activeServer.timeFormat,
                            timeOnly: true,
                          ),
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.paused_title.tr(),
                        item: Text(
                          TimeHelper.simple(widget.history.pausedCounter!),
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.duration_title.tr(),
                        item: Text(
                          TimeHelper.simple(widget.history.duration!),
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.progress_title.tr(),
                        item: Text(
                          '${widget.history.percentComplete.toString()}%',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
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
        // CrossAxisAlignment.baseline can't actually calculate any intrinsics sizes here because baseline metrics are
        // only available after layout (and the intrinsics are explicitly not doing a full layout).

        // As a result we cannot precisely align the bottom of the text inside an IntrinsicHeight.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
