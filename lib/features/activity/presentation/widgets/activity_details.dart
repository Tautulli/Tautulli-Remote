import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';
import 'platform_icon.dart';
import 'stream_icons.dart';
import 'time_left.dart';

class ActivityDetails extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDetails({
    super.key,
    required this.activity,
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
                      _Title(activity),
                      _Subtitle(activity),
                      if ([MediaType.episode].contains(activity.mediaType))
                        BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                            state as SettingsSuccess;

                            return _ItemDetails(
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
                  PlatformIcon(platformName: activity.platformName),
                  StreamIcons(activity: activity),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                return Expanded(
                  child: Text(
                    state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : activity.friendlyName ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            const Gap(4),
            TimeLeft(activity: activity),
          ],
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final ActivityModel activity;

  const _Title(this.activity);

  @override
  Widget build(BuildContext context) {
    int? maxLines;
    String text;

    switch (activity.mediaType) {
      case (MediaType.episode):
        maxLines = 1;
        text = activity.grandparentTitle ?? '';
        break;
      case (MediaType.movie):
        maxLines = 3;
        text = activity.title ?? '';
        break;
      default:
        maxLines = 2;
        text = activity.title ?? '';
    }

    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 17,
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  final ActivityModel activity;
  final int? maxLines;

  const _Subtitle(
    this.activity, {
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    int? lines;
    String text;

    switch (activity.mediaType) {
      case (MediaType.episode):
        lines = 2;
        text = activity.title ?? '';
        break;
      case (MediaType.movie):
        lines = 1;
        text = activity.year.toString();
        break;
      default:
        lines = 1;
        text = activity.grandparentTitle ?? '';
        break;
    }

    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? lines,
    );
  }
}

class _ItemDetails extends StatelessWidget {
  final ActivityModel activity;

  final String? dateFormat;

  const _ItemDetails(
    this.activity, {
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final mediaType = activity.mediaType;

    if (mediaType == MediaType.movie && activity.year != null) {
      return Text(
        activity.year.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode &&
        activity.live == true &&
        activity.mediaIndex == null &&
        activity.originallyAvailableAt != null) {
      return Text(
        TimeHelper.cleanDateTime(
          activity.originallyAvailableAt!,
          dateOnly: true,
          dateFormat: dateFormat,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode && (activity.parentMediaIndex != null || activity.mediaIndex != null)) {
      return Text(
        '${activity.parentMediaIndex != null ? "S${activity.parentMediaIndex}" : ""}${activity.parentMediaIndex != null && activity.mediaIndex != null ? " • " : ""}${activity.mediaIndex != null ? "E${activity.mediaIndex}" : ""}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.track) {
      return Text(
        activity.parentTitle ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
