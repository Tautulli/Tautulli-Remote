import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ActivityRefreshRateActionSheet extends StatefulWidget {
  final int initialValue;

  const ActivityRefreshRateActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  State<ActivityRefreshRateActionSheet> createState() => _ActivityRefreshRateActionSheetState();
}

class _ActivityRefreshRateActionSheetState extends State<ActivityRefreshRateActionSheet> {
  late int _refresh;

  @override
  void initState() {
    super.initState();
    _refresh = widget.initialValue;
  }

  void _refreshValueChanged(int value) {
    setState(() {
      _refresh = value;
      context.read<SettingsBloc>().add(
            SettingsUpdateRefreshRate(value),
          );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text(LocaleKeys.activity_refresh_rate_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: _refresh == 5,
          onPressed: () {
            _refreshValueChanged(5);
          },
          child: Text(
            '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _refresh == 7,
          onPressed: () {
            _refreshValueChanged(7);
          },
          child: Text(
            '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _refresh == 10,
          onPressed: () {
            _refreshValueChanged(10);
          },
          child: Text(
            '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _refresh == 15,
          onPressed: () {
            _refreshValueChanged(15);
          },
          child: Text(
            '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _refresh == 20,
          onPressed: () {
            _refreshValueChanged(20);
          },
          child: Text(
            '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _refresh == 0,
          onPressed: () {
            _refreshValueChanged(0);
          },
          child: Text(
            LocaleKeys.disabled_title.tr(),
          ),
        ),
      ],
    );
  }
}
