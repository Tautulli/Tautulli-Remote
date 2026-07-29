import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/cupertino/cupertino_style_notifications_privacy_list_tile.dart';
import '../../widgets/cupertino/cupertino_style_notifications_privacy_text.dart';

class CupertinoStyleNotificationsPrivacyPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool showToggle;

  const CupertinoStyleNotificationsPrivacyPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    this.showToggle = true,
  });

  static const routeName = '/notifications_privacy';

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleNotificationsPrivacyView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      showToggle: showToggle,
    );
  }
}

class CupertinoStyleNotificationsPrivacyView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool showToggle;

  const CupertinoStyleNotificationsPrivacyView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.showToggle,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStylePageScaffold(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.notifications_data_privacy_title).tr(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoStyleNotificationsPrivacyText(),
            if (showToggle)
              const CupertinoStyleListSection(
                margin: EdgeInsets.fromLTRB(8, 20, 8, 8),
                children: [
                  CupertinoStyleNotificationsPrivacyListTile(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
