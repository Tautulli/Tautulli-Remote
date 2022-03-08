import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/datasources/changelog_data_source.dart';
import '../widgets/changelog_item.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key? key}) : super(key: key);

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return const ChangelogView();
  }
}

class ChangelogView extends StatelessWidget {
  const ChangelogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.changelog_title).tr(),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Navigator.of(context).pushNamed('/donate');
            },
            icon: const FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
              size: 18,
            ),
            label: const Text(LocaleKeys.donate_title).tr(),
          ),
        ],
      ),
      body: PageBody(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: changelog['data'].length,
          itemBuilder: (context, index) {
            return ChangelogItem(
              changelog['data'][index],
              bottomPadding: index < changelog['data'].length - 1,
            );
          },
        ),
      ),
    );
  }
}
