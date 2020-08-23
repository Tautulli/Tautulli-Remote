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
    const Color textColor = TautulliColorPalette.not_white;
    const double textSize = 13;

    return Container(
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? TautulliColorPalette.gunmetal
            : Colors.transparent,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 12,
              right: 6,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Text(
                    "${logMap['timestamp']['year']}-${logMap['timestamp']['month']}-${logMap['timestamp']['day']}",
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                    ),
                  ),
                  Text(
                    "${logMap['timestamp']['hour']}:${logMap['timestamp']['minute']}:${logMap['timestamp']['second']}",
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 86,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 6,
            ),
            child: Text(
              logMap['level'],
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 6,
                right: 12,
              ),
              child: Text(
                logMap['message'],
                style: TextStyle(
                  color: textColor,
                  fontSize: textSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
