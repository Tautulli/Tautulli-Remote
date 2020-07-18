import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class LogTableRow extends StatelessWidget {
  final int index;
  final Map<String, dynamic> logMap;

  const LogTableRow({
    Key key,
    @required this.index,
    @required this.logMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (index % 2 == 0) ? Colors.black12 : PlexColorPalette.river_bed,
      ),
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
            child: Column(
              children: <Widget>[
                Text(
                    "${logMap['timestamp']['year']}-${logMap['timestamp']['month']}-${logMap['timestamp']['day']}"),
                Text(
                    "${logMap['timestamp']['hour']}:${logMap['timestamp']['minute']}:${logMap['timestamp']['second']}"),
              ],
            ),
          ),
          Container(
            width: 86,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 6,
            ),
            child: Text(logMap['level']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 6,
                right: 12,
              ),
              child: Text(logMap['message']),
            ),
          ),
        ],
      ),
    );
  }
}
