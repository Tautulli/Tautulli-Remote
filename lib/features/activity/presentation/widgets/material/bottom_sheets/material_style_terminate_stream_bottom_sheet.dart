import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/helpers/time_helper.dart';
import '../../../../../../core/types/media_type.dart';
import '../../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../data/models/activity_model.dart';

class MaterialStyleTerminateStreamBottomSheet extends StatelessWidget {
  final ActivityModel activity;
  final TextEditingController controller;

  const MaterialStyleTerminateStreamBottomSheet({
    super.key,
    required this.activity,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: MaterialStyleBottomSheetScaffold(
        leading: TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        trailing: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(LocaleKeys.terminate_title).tr(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              LocaleKeys.terminate_stream_dialog_title,
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 12),
            _TerminateStreamMediaInfo(activity: activity),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
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
                helperText: LocaleKeys.terminate_message_title.tr(),
                hintText: LocaleKeys.terminate_stream_dialog_default_message.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

            return Text(activity.friendlyName ?? '').sensitive();
          },
        ),
        ...rows,
      ],
    );
  }
}
