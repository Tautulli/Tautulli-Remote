import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/helpers/time_helper.dart';
import '../../../../../../core/types/media_type.dart';
import '../../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../data/models/activity_model.dart';
import '../buttons/cupertino_style_bottom_sheet_terminate_button.dart';

class CupertinoStyleTerminateStreamBottomSheet extends StatelessWidget {
  final ActivityModel activity;
  final TextEditingController controller;

  const CupertinoStyleTerminateStreamBottomSheet({
    super.key,
    required this.activity,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleModalPopupScaffold(
      leading: const CupertinoStyleBottomSheetCancelButton(),
      trailing: const CupertinoStyleBottomSheetTerminateButton(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          children: [
            const Text(
              LocaleKeys.terminate_stream_dialog_title,
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ).tr(),
            const Gap(12),
            _TerminateStreamMediaInfo(activity: activity),
            const Gap(12),
            CupertinoTextField(
              controller: controller,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              placeholder: LocaleKeys.terminate_stream_dialog_default_message.tr(),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: CupertinoColors.separator.resolveFrom(context)),
                ),
              ),
            ),
            const Gap(4),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  LocaleKeys.terminate_message_title.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
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
