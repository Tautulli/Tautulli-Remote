import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/cupertino/cupertino_style_onesignal_data_privacy_list_tile.dart';
import '../../widgets/cupertino/cupertino_style_onesignal_data_privacy_text.dart';

class CupertinoStyleOnesignalDataPrivacyPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool showToggle;

  const CupertinoStyleOnesignalDataPrivacyPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    this.showToggle = true,
  });

  static const routeName = '/onesignal_privacy';

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleOnesignalDataPrivacyView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      showToggle: showToggle,
    );
  }
}

class CupertinoStyleOnesignalDataPrivacyView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool showToggle;

  const CupertinoStyleOnesignalDataPrivacyView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.showToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.onesignal_data_privacy_title).tr(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoStyleOnesignalDataPrivacyText(),
            if (showToggle)
              const CupertinoStyleListSection(
                margin: EdgeInsets.fromLTRB(8, 20, 8, 8),
                children: [
                  CupertinoStyleOnesignalDataPrivacyListTile(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
