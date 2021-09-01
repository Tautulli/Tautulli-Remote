// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/ip_address_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../activity/domain/entities/geo_ip.dart';
import '../../../activity/presentation/bloc/geo_ip_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/history.dart';

class HistoryInfo extends StatefulWidget {
  final History item;
  final Server server;
  final bool maskSensitiveInfo;

  const HistoryInfo({
    Key key,
    @required this.item,
    @required this.server,
    this.maskSensitiveInfo = false,
  }) : super(key: key);

  @override
  _HistoryInfoState createState() => _HistoryInfoState();
}

class _HistoryInfoState extends State<HistoryInfo> {
  @override
  void initState() {
    super.initState();
    context.read<GeoIpBloc>().add(
          GeoIpLoad(
            tautulliId: widget.server.tautulliId,
            ipAddress: widget.item.ipAddress,
            settingsBloc: context.read<SettingsBloc>(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isPublicIp = false;
    try {
      isPublicIp = IpAddressHelper.isPublic(widget.item.ipAddress);
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemRow(
            title: LocaleKeys.history_details_user.tr(),
            item: _FormattedText(
              widget.maskSensitiveInfo
                  ? '*${LocaleKeys.masked_info_user.tr()}*'
                  : widget.item.friendlyName,
            ),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_platform.tr(),
            item: _FormattedText(
              widget.item.platform,
            ),
          ),
          if (widget.item.product != null)
            _ItemRow(
              title: LocaleKeys.history_details_product.tr(),
              item: _FormattedText(widget.item.product),
            ),
          _ItemRow(
            title: LocaleKeys.history_details_player.tr(),
            item: _FormattedText(widget.item.player),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_ip_address.tr(),
            item: _FormattedText(
              widget.maskSensitiveInfo
                  ? '*${LocaleKeys.masked_info_ip_address.tr()}*'
                  : widget.item.ipAddress,
            ),
          ),
          if (isPublicIp)
            BlocBuilder<GeoIpBloc, GeoIpState>(
              builder: (context, state) {
                if (state is GeoIpSuccess) {
                  if (state.geoIpMap.containsKey(widget.item.ipAddress)) {
                    GeoIpItem geoIpItem = state.geoIpMap[widget.item.ipAddress];
                    if (geoIpItem != null && geoIpItem.code != 'ZZ') {
                      String text;

                      if (widget.item.ipAddress != 'N/A') {
                        text = widget.maskSensitiveInfo
                            ? '*${LocaleKeys.masked_info_location.tr()}*'
                            : '${geoIpItem.city}, ${geoIpItem.region} ${geoIpItem.code}';
                      } else {
                        text = LocaleKeys.media_details_na.tr();
                      }

                      return _ItemRow(
                        title: '',
                        item: _FormattedText(text),
                      );
                    }
                    return const SizedBox(height: 0, width: 0);
                  }
                  return _ItemRow(
                    title: '',
                    item: _FormattedText(
                      LocaleKeys.media_details_location_error.tr(),
                    ),
                  );
                }
                return _ItemRow(
                  title: '',
                  item: Row(
                    children: [
                      SizedBox(
                        height: 19,
                        width: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: _FormattedText(
                          LocaleKeys.media_details_location_loading.tr(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6,
              bottom: 2,
            ),
            child: Divider(
              color: Colors.grey,
              indent: MediaQuery.of(context).size.width / 3,
              endIndent: MediaQuery.of(context).size.width / 3,
            ),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_date.tr(),
            item: _FormattedText(
              TimeFormatHelper.cleanDateTime(
                widget.item.date,
                dateFormat: widget.server.dateFormat,
                dateOnly: true,
              ),
            ),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_started.tr(),
            item: _FormattedText(
              TimeFormatHelper.cleanDateTime(
                widget.item.started,
                timeFormat: widget.server.timeFormat,
                timeOnly: true,
              ),
            ),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_stopped.tr(),
            item: _FormattedText(
              TimeFormatHelper.cleanDateTime(
                widget.item.stopped,
                timeFormat: widget.server.timeFormat,
                timeOnly: true,
              ),
            ),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_paused.tr(),
            item: _FormattedText(
              TimeFormatHelper.pretty(widget.item.pausedCounter),
            ),
          ),
          _ItemRow(
            title: LocaleKeys.general_details_duration.tr(),
            item: _FormattedText(
              TimeFormatHelper.pretty(widget.item.duration),
            ),
          ),
          _ItemRow(
            title: LocaleKeys.history_details_watched.tr(),
            item: _FormattedText('${widget.item.percentComplete}%'),
          ),
        ],
      ),
    );
  }
}

class _FormattedText extends StatelessWidget {
  final String text;

  const _FormattedText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        height: 1.4,
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final Widget item;

  const _ItemRow({
    @required this.title,
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: item,
          ),
          // Expanded(
          //   child: Text(
          //     item,
          //     style: TextStyle(
          //       fontSize: 16,
          //       height: 1.4,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
