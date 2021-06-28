import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../data/datasource/changelog_data_source.dart';
import '../widgets/changelog_item.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key key}) : super(key: key);

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(LocaleKeys.changelog_page_title).tr(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: changelog['data'].map<Widget>((release) {
              return ChangelogItem(
                release: release,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
