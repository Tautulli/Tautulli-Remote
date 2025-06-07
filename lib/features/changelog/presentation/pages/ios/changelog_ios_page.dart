import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/datasources/changelog_data_source.dart';
import '../../widgets/ios/changelog_ios_item.dart';

class ChangelogIosPage extends StatelessWidget {
  const ChangelogIosPage({super.key});

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return const ChangelogIosView();
  }
}

class ChangelogIosView extends StatelessWidget {
  const ChangelogIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.changelog_title).tr(),
      leading: CupertinoNavigationBarBackButton(
        //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
        onPressed: () => Navigator.of(context).pop(),
      ),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.solidHeart,
              color: CupertinoColors.systemRed,
            ),
            const Gap(8),
            const Text(LocaleKeys.donate_title).tr(),
          ],
        ),
        onPressed: () {
          //TODO: Navigate to donate page
          // Navigator.of(context).push(
          //   CupertinoPageRoute(
          //     builder: (context) => const DonateIosPage(),
          //   ),
          // );
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
