import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/user_watch_time_stat_model.dart';
import '../../../../../translations/locale_keys.g.dart';

class WatchTimeStatTitleText extends StatelessWidget {
  final UserWatchTimeStatModel watchTimeStat;

  const WatchTimeStatTitleText({
    super.key,
    required this.watchTimeStat,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _title(),
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16),
    );
  }

  String _title() {
    if (watchTimeStat.queryDays == 0) {
      return LocaleKeys.all_time_title.tr();
    } else if (watchTimeStat.queryDays == 1) {
      return '24 ${LocaleKeys.hours_title.tr()}';
    } else {
      return '${watchTimeStat.queryDays} ${LocaleKeys.days_title.tr()}';
    }
  }
}
