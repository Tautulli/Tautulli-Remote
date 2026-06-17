import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import 'activity_info_widgets.dart';
import 'platform_icon.dart';
import 'stream_icons.dart';
import 'time_left.dart';

class ActivityDetails extends StatelessWidget {
  final ActivityModel activity;
  final Color iconColor;

  const ActivityDetails({
    super.key,
    required this.activity,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleRow(activity),
                      SubtitleRow(activity),
                      if ([MediaType.episode].contains(activity.mediaType))
                        BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                            state as SettingsSuccess;

                            return ItemDetailsRow(
                              activity,
                              dateFormat: state.appSettings.activeServer.dateFormat,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PlatformIcon(
                    platformName: activity.platformName,
                    iconColor: iconColor,
                  ),
                  if (activity.mediaType != MediaType.photo)
                    StreamIcons(
                      activity: activity,
                      iconColor: iconColor,
                    ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                activity.friendlyName ?? '',
                overflow: TextOverflow.ellipsis,
              ).sensitive(),
            ),
            const Gap(4),
            TimeLeft(activity: activity),
            if (activity.mediaType == MediaType.photo)
              StreamIcons(
                activity: activity,
                iconColor: iconColor,
              ),
          ],
        ),
      ],
    );
  }
}
