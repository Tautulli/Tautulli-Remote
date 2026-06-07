import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../donate/presentation/pages/cupertino/cupertino_style_donate_page.dart';
import '../../../data/datasources/changelog_data_source.dart';
import '../../widgets/ios/changelog_ios_item.dart';

class ChangelogIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const ChangelogIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return ChangelogIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class ChangelogIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const ChangelogIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.changelog_title).tr(),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.heart_solid,
              color: CupertinoColors.systemRed,
            ),
            const Gap(4),
            Text(
              LocaleKeys.donate_title,
              style: TextStyle(color: ThemeHelper.cupertinoNavigationBarItemColor()),
            ).tr(),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleDonatePage(
                showBackButton: true,
                previousPageTitle: LocaleKeys.changelog_title.tr(),
              ),
            ),
          );
        },
      ),
      child: CupertinoScrollbar(
        child: ListView(
          children: _buildChangelogEntries(changelog['data']),
        ),
      ),
    );
  }

  List<Widget> _buildChangelogEntries(List<Map<String, dynamic>> data) {
    List<Widget> entries = [];

    for (int i = 0; i < data.length; i++) {
      entries.add(
        ChangelogIosItem(
          data[i],
          bottomPadding: i < data.length - 1,
        ),
      );
    }

    return entries;
  }
}
