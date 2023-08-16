import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/statistic_data_model.dart';

class TopStatisticDetails extends StatelessWidget {
  final StatisticDataModel statData;

  const TopStatisticDetails({
    super.key,
    required this.statData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          statData.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.plays_title.tr(),
              ),
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: statData.totalPlays.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
              ),
            ],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        _duration(context),
      ],
    );
  }

  Widget _duration(BuildContext context) {
    Map<String, int> durationMap = TimeHelper.durationMap(
      statData.totalDuration ?? const Duration(seconds: 0),
    );

    return RichText(
      text: TextSpan(
        children: [
          if (durationMap['day']! > 1 || durationMap['hour']! > 1 || durationMap['min']! > 1 || durationMap['sec']! > 1)
            TextSpan(
              text: '${LocaleKeys.time_title.tr()} ',
            ),
          if (durationMap['day']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                const TextSpan(
                  text: ' days ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          if (durationMap['hour']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                const TextSpan(
                  text: ' hrs ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          if (durationMap['min']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                const TextSpan(
                  text: ' mins',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['sec'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                const TextSpan(
                  text: ' secs',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
