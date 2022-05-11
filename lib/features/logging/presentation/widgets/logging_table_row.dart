import 'package:f_logs/model/flog/log.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/time_helper.dart';

class LoggingTableRow extends StatelessWidget {
  final Log log;
  final Color backgroundColor;

  const LoggingTableRow(
    this.log, {
    super.key,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    const double textSize = 13;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Row(
        children: [
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
                  if (log.timeInMillis != null)
                    Text(
                      TimeHelper.logDate(log.timeInMillis!),
                      style: const TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  if (log.timeInMillis != null)
                    Text(
                      TimeHelper.logTime(log.timeInMillis!),
                      style: const TextStyle(
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
              log.logLevel.toString().split('.')[1],
              style: const TextStyle(
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
                log.text ?? '',
                style: const TextStyle(
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
