import 'package:flutter/widgets.dart';

import '../../../../../../core/helpers/time_helper.dart';
import '../../../domain/entities/notification_log_entry.dart';

class NotificationLogsTableRow extends StatelessWidget {
  final NotificationLogEntry entry;
  final Color? backgroundColor;

  const NotificationLogsTableRow(
    this.entry, {
    super.key,
    this.backgroundColor = const Color(0x00000000),
  });

  String _encryptLabel() {
    return (entry.encrypted ?? false) ? 'true' : 'false';
  }

  String _statusSummary() {
    if (entry.decryptionSuccess == false) {
      return 'Decrypt failed: ${entry.decryptionError ?? 'unknown'}';
    }
    if (entry.imageRequested && entry.imageSuccess == false) {
      return 'Image failed: ${entry.imageError ?? 'unknown'}';
    }
    if (entry.imageRequested && entry.imageSuccess == true) {
      return 'OK (image)';
    }
    return 'OK';
  }

  @override
  Widget build(BuildContext context) {
    const double textSize = 13;

    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    TimeHelper.logDate(entry.timestamp.millisecondsSinceEpoch),
                    style: const TextStyle(fontSize: textSize),
                  ),
                  Text(
                    TimeHelper.logTime(entry.timestamp.millisecondsSinceEpoch),
                    style: const TextStyle(fontSize: textSize),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Text(
              _encryptLabel(),
              style: const TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 6, right: 12),
              child: Text(
                _statusSummary(),
                style: const TextStyle(fontSize: textSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
