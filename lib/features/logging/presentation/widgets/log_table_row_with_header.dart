import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
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
                  'Timestamp',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
              ),
              Container(
                width: 86,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                child: const Text(
                  'Level',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 6,
                    right: 12,
                  ),
                  child: Text(
                    'Message',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
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
