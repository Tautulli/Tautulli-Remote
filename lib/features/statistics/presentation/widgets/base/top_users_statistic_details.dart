import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../core/widgets/base/statistic_duration_rich_text.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/statistic_data_model.dart';

class TopUsersStatisticDetails extends StatelessWidget {
  final StatisticDataModel statData;
  final Color? textColor;

  const TopUsersStatisticDetails({
    super.key,
    required this.statData,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Text(
              statData.friendlyName ?? LocaleKeys.name_missing.tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ).sensitive();
          },
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
              color: textColor,
            ),
          ),
        ),
        StatisticDurationRichText(
          duration: statData.totalDuration ?? const Duration(seconds: 0),
          textColor: textColor,
        ),
      ],
    );
  }
}
