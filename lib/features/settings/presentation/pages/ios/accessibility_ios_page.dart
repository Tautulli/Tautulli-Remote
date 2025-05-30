import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/accessibility_font_ios_group.dart';
import '../../widgets/ios/groups/accessibility_theme_ios_group.dart';
import '../../widgets/ios/groups/accessibility_visuals_ios_group.dart';

class AccessibilityIosPage extends StatelessWidget {
  const AccessibilityIosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccessibilityIosView();
  }
}

class AccessibilityIosView extends StatelessWidget {
  const AccessibilityIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.accessibility_title).tr(),
      leading: CupertinoNavigationBarBackButton(
        //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: ListView(
        children: const [
          AccessibilityFontIosGroup(),
          AccessibilityThemeIosGroup(),
          AccessibilityVisualsIosGroup(),
        ],
      ),
    );
  }
}
