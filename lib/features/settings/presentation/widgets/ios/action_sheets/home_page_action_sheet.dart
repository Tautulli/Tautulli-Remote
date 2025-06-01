import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class HomePageActionSheet extends StatelessWidget {
  final String initialValue;

  const HomePageActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void homePageChanged(String value) {
      context.read<SettingsBloc>().add(
            SettingsUpdateHomePage(value),
          );
      Navigator.of(context).pop();
    }

    return CupertinoActionSheet(
      title: const Text(LocaleKeys.home_page_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'activity',
          onPressed: () {
            homePageChanged('activity');
          },
          child: const Text(LocaleKeys.activity_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'history',
          onPressed: () {
            homePageChanged('history');
          },
          child: const Text(LocaleKeys.history_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'recent',
          onPressed: () {
            homePageChanged('recent');
          },
          child: const Text(LocaleKeys.recently_added_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'libraries',
          onPressed: () {
            homePageChanged('libraries');
          },
          child: const Text(LocaleKeys.libraries_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'users',
          onPressed: () {
            homePageChanged('users');
          },
          child: const Text(LocaleKeys.users_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'statistics',
          onPressed: () {
            homePageChanged('statistics');
          },
          child: const Text(LocaleKeys.statistics_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 'graphs',
          onPressed: () {
            homePageChanged('graphs');
          },
          child: const Text(LocaleKeys.graphs_title).tr(),
        ),
      ],
    );
  }
}
