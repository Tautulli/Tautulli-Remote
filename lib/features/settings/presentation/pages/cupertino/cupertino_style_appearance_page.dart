import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/cupertino/groups/cupertino_style_appearance_enhancements_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_dynamic_color_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_styles_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_themes_group.dart';

class CupertinoStyleAppearancePage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAppearancePage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleAppearanceView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleAppearanceView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAppearanceView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.appearance_title).tr(),
      child: ListView(
        children: const [
          CupertinoStyleStylesGroup(),
          CupertinoStyleThemesGroup(),
          CupertinoStyleDynamicColorGroup(),
          CupertinoStyleAppearanceEnhancementsGroup(),
        ],
      ),
    );
  }
}
