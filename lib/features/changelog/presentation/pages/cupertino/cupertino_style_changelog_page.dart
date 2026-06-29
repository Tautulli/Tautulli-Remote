import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../donate/presentation/pages/cupertino/cupertino_style_donate_page.dart';
import '../../../data/datasources/changelog_data_source.dart';
import '../../widgets/cupertino/cupertino_style_changelog_item.dart';

class CupertinoStyleChangelogPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleChangelogPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleChangelogView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleChangelogView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleChangelogView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleChangelogView> createState() => _CupertinoStyleChangelogViewState();
}

class _CupertinoStyleChangelogViewState extends State<CupertinoStyleChangelogView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStylePageScaffold(
      showBackButton: widget.showBackButton,
      previousPageTitle: widget.previousPageTitle,
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
            const Text(
              LocaleKeys.donate_title,
              style: TextStyle(color: ThemeHelper.cupertinoNavigationBarItemColor),
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
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: _buildChangelogEntries(changelog['data']),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChangelogEntries(List<Map<String, dynamic>> data) {
    List<Widget> entries = [];

    for (int i = 0; i < data.length; i++) {
      entries.add(
        CupertinoStyleChangelogItem(
          data[i],
          bottomPadding: i < data.length - 1,
        ),
      );
    }

    return entries;
  }
}
