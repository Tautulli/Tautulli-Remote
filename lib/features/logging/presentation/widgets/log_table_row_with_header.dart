// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import 'log_table_row.dart';

class LogTableRowWithHeader extends StatelessWidget {
  final int index;
  final Map<String, dynamic> logMap;

  const LogTableRowWithHeader({
    Key key,
    @required this.index,
    @required this.logMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double textSize = 13;

    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(color: TautulliColorPalette.midnight),
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                padding: const EdgeInsets.only(
                  top: 14,
                  bottom: 14,
                  left: 12,
                ),
                child: const Text(
                  LocaleKeys.logs_timestamp,
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ).tr(),
              ),
              Container(
                width: 86,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                child: const Text(
                  LocaleKeys.logs_level,
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ).tr(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 6,
                    right: 12,
                  ),
                  child: const Text(
                    LocaleKeys.logs_message,
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
        LogTableRow(
          index: index,
          logMap: logMap,
        ),
      ],
    );
  }
}
