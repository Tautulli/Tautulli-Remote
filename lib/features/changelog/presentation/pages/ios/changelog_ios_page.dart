import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../donate/presentation/pages/ios/donate_ios_page.dart';
import '../../../data/datasources/changelog_data_source.dart';
import '../../widgets/ios/changelog_ios_item.dart';

class ChangelogIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const ChangelogIosPage({
    super.key,
    this.previousPageTitle,
  });

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return ChangelogIosView(
      previousPageTitle: previousPageTitle,
    );
  }
}

class ChangelogIosView extends StatelessWidget {
  final String? previousPageTitle;

  const ChangelogIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.changelog_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: previousPageTitle,
      ),
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
            const Gap(8),
            const Text(LocaleKeys.donate_title).tr(),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => DonateIosPage(
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
