import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/activity_model.dart';

class TimeEta extends StatelessWidget {
  final ServerModel server;
  final ActivityModel activity;

  const TimeEta({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${LocaleKeys.eta_title.tr()}: ${TimeHelper.eta(
        activity.duration!,
        activity.progressPercent,
        server.timeFormat,
      )}',
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }
}
