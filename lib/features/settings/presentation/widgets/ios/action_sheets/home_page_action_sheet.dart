import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class HomePageActionSheet extends StatefulWidget {
  final String initialValue;

  const HomePageActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  State<HomePageActionSheet> createState() => _HomePageActionSheetState();
}

class _HomePageActionSheetState extends State<HomePageActionSheet> {
  late String _homePage;

  @override
  void initState() {
    super.initState();
    _homePage = widget.initialValue;
  }

  void _homePageChanged(String value) {
    setState(() {
      _homePage = value;
      context.read<SettingsBloc>().add(
            SettingsUpdateHomePage(value),
          );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text(LocaleKeys.home_page_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'activity',
          onPressed: () {
            _homePageChanged('activity');
          },
          child: const Text(LocaleKeys.activity_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'history',
          onPressed: () {
            _homePageChanged('history');
          },
          child: const Text(LocaleKeys.history_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'recent',
          onPressed: () {
            _homePageChanged('recent');
          },
          child: const Text(LocaleKeys.recently_added_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'libraries',
          onPressed: () {
            _homePageChanged('libraries');
          },
          child: const Text(LocaleKeys.libraries_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'users',
          onPressed: () {
            _homePageChanged('users');
          },
          child: const Text(LocaleKeys.users_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'statistics',
          onPressed: () {
            _homePageChanged('statistics');
          },
          child: const Text(LocaleKeys.statistics_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _homePage == 'graphs',
          onPressed: () {
            _homePageChanged('graphs');
          },
          child: const Text(LocaleKeys.graphs_title).tr(),
        ),
      ],
    );
  }
}
