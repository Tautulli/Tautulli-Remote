import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/time_helper.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/statistic_data_model.dart';

class MostConcurrentStatisticDetails extends StatelessWidget {
  final StatisticDataModel statData;
  final Color? textColor;

  const MostConcurrentStatisticDetails({
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
                text: LocaleKeys.streams_title.tr(),
              ),
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: statData.count.toString(),
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
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Text(
              TimeHelper.cleanDateTime(
                statData.started!,
                dateFormat: state.appSettings.activeServer.dateFormat,
                timeFormat: state.appSettings.activeServer.timeFormat,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 13,
              ),
            );
          },
        ),
      ],
    );
  }
}
