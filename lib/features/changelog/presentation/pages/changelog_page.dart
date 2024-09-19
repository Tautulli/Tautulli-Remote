import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../donate/presentation/pages/donate_page.dart';
import '../../data/datasources/changelog_data_source.dart';
import '../widgets/changelog_item.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return const ChangelogView();
  }
}

class ChangelogView extends StatelessWidget {
  const ChangelogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.changelog_title).tr(),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const DonatePage(
                    showDrawer: false,
                  ),
                ),
              );
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
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: _buildChangelogEntries(changelog['data']),
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildChangelogEntries(List<Map<String, dynamic>> data) {
  List<Widget> entries = [];

  for (int i = 0; i < data.length; i++) {
    entries.add(
      ChangelogItem(
        data[i],
        bottomPadding: i < data.length - 1,
      ),
    );
  }

  return entries;
}
