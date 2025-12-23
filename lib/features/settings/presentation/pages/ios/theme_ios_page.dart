import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/dynamic_color_ios_group.dart';
import '../../widgets/ios/groups/framework_ios_group.dart';
import '../../widgets/ios/groups/theme_enhancements_ios_group.dart';
import '../../widgets/ios/groups/themes_ios_group.dart';

class ThemeIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const ThemeIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class ThemeIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const ThemeIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.themes_title).tr(),
      child: ListView(
        children: const [
          FrameworkIosGroup(),
          ThemesIosGroup(),
          DynamicColorIosGroup(),
          ThemeEnhancementsIosGroup(),
        ],
      ),
    );
  }
}
