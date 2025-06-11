import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/dynamic_color_ios_group.dart';
import '../../widgets/ios/groups/theme_enhancements_ios_group.dart';
import '../../widgets/ios/groups/themes_ios_group.dart';

class ThemeIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const ThemeIosPage({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeIosView(
      previousPageTitle: previousPageTitle,
    );
  }
}

class ThemeIosView extends StatelessWidget {
  final String? previousPageTitle;

  const ThemeIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.themes_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: previousPageTitle,
      ),
      child: ListView(
        children: const [
          ThemesIosGroup(),
          DynamicColorIosGroup(),
          ThemeEnhancementsIosGroup(),
        ],
      ),
    );
  }
}
