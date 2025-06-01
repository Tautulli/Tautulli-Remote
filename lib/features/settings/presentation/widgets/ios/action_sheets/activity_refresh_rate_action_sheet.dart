import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ActivityRefreshRateActionSheet extends StatelessWidget {
  final int initialValue;

  const ActivityRefreshRateActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void refreshValueChanged(int value) {
      context.read<SettingsBloc>().add(
            SettingsUpdateRefreshRate(value),
          );
      Navigator.of(context).pop();
    }

    return CupertinoActionSheet(
      title: const Text(LocaleKeys.activity_refresh_rate_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 5,
          onPressed: () {
            refreshValueChanged(5);
          },
          child: Text(
            '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 7,
          onPressed: () {
            refreshValueChanged(7);
          },
          child: Text(
            '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 10,
          onPressed: () {
            refreshValueChanged(10);
          },
          child: Text(
            '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 15,
          onPressed: () {
            refreshValueChanged(15);
          },
          child: Text(
            '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 20,
          onPressed: () {
            refreshValueChanged(20);
          },
          child: Text(
            '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 0,
          onPressed: () {
            refreshValueChanged(0);
          },
          child: Text(
            LocaleKeys.disabled_title.tr(),
          ),
        ),
      ],
    );
  }
}
