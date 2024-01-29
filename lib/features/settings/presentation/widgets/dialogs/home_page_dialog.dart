import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';

class HomePageDialog extends StatefulWidget {
  final String initialValue;

  const HomePageDialog({
    super.key,
    required this.initialValue,
  });

  @override
  HomePageDialogState createState() => HomePageDialogState();
}

class HomePageDialogState extends State<HomePageDialog> {
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
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      title: const Text(LocaleKeys.home_page_title).tr(),
      children: [
        RadioListTile(
          title: const Text(LocaleKeys.activity_title).tr(),
          value: 'activity',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.history_title).tr(),
          value: 'history',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.recently_added_title).tr(),
          value: 'recent',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.libraries_title).tr(),
          value: 'libraries',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.users_title).tr(),
          value: 'users',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.statistics_title).tr(),
          value: 'statistics',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.graphs_title).tr(),
          value: 'graphs',
          groupValue: _homePage,
          onChanged: (value) => _homePageChanged(value as String),
        ),
      ],
    );
  }
}
