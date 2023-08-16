import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/statistic_data_model.dart';

class LastWatchedStatisticDetails extends StatelessWidget {
  final StatisticDataModel statData;

  const LastWatchedStatisticDetails({
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
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Text(
              state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : statData.friendlyName ?? 'name missing',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.streamed_title.tr(),
              ),
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: statData.lastWatch != null ? TimeHelper.moment(statData.lastWatch) : LocaleKeys.never.tr(),
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
      ],
    );
  }
}
