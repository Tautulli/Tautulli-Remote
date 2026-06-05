import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../widgets/ios/groups/appearance_enhancements_ios_group.dart';
import '../../widgets/ios/groups/dynamic_color_ios_group.dart';
import '../../widgets/ios/groups/styles_ios_group.dart';
import '../../widgets/ios/groups/themes_ios_group.dart';

class AppearanceIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AppearanceIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppearanceIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class AppearanceIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AppearanceIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      previousPageTitle: previousPageTitle,
      //TODO:  Create translation key
      middle: const Text('Appearance'),
      child: ListView(
        children: const [
          StylesIosGroup(),
          ThemesIosGroup(),
          DynamicColorIosGroup(),
          AppearanceEnhancementsIosGroup(),
        ],
      ),
    );
  }
}
