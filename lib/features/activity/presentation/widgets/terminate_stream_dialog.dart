import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/string_helper.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';

Future<bool> showTerminateSessionDialog({
  required BuildContext context,
  required TextEditingController controller,
  required ActivityModel activity,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(LocaleKeys.terminate_stream_dialog_title).tr(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TerminateStreamMediaInfo(activity: activity),
            TextFormField(
              controller: controller,
              maxLines: 2,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                helperText: LocaleKeys.terminate_message_title.tr(),
                hintText: LocaleKeys.terminate_stream_dialog_default_message.tr(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(LocaleKeys.cancel_title).tr(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(LocaleKeys.terminate_title).tr(),
          ),
        ],
      );
    },
  );
}

class _TerminateStreamMediaInfo extends StatelessWidget {
  final ActivityModel activity;

  const _TerminateStreamMediaInfo({
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    switch (activity.mediaType) {
      case MediaType.clip:
        rows.add(Text(activity.title ?? ''));
        rows.add(Text('(${StringHelper.capitalize(activity.subType ?? '')})'));
        break;
      case MediaType.episode:
        rows.add(Text(activity.grandparentTitle ?? ''));
        rows.add(Text(activity.title ?? ''));
        if (activity.parentMediaIndex != null && activity.mediaIndex != null) {
          rows.add(Text('S${activity.parentMediaIndex} • E${activity.mediaIndex}'));
        } else if (activity.originallyAvailableAt != null && activity.live == true) {
          rows.add(Text(TimeHelper.cleanDateTime(activity.originallyAvailableAt!)));
        }
        break;
      case MediaType.movie:
        rows.add(Text(activity.title ?? ''));
        rows.add(Text(activity.year.toString()));
        break;
      case MediaType.track:
        rows.add(Text(activity.title ?? ''));
        rows.add(Text(activity.grandparentTitle ?? ''));
        rows.add(Text(activity.parentTitle ?? ''));
        rows.add(Text(activity.year.toString()));
        break;
      default:
    }

    return Column(
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Text(
              state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : activity.friendlyName ?? '',
            );
          },
        ),
        ...rows,
      ],
    );
  }
}
