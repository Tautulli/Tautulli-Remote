import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
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
    return PageScaffoldCupertino(
      previousPageTitle: previousPageTitle,
      //TODO:  Create translation key
      middle: const Text('Appearance'),
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
