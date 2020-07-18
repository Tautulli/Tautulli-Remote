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
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: PlexColorPalette.shark),
          child: Row(
            children: <Widget>[
              Container(
                width: 97,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 12,
                  right: 6,
                ),
                child: Text('Timestamp'),
              ),
              Container(
                width: 86,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                child: Text('Level'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 6,
                    right: 12,
                  ),
                  child: Text('Message'),
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
