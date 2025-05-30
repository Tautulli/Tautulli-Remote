import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/dynamic_color_ios_group.dart';
import '../../widgets/ios/groups/theme_enhancements_ios_group.dart';
import '../../widgets/ios/groups/themes_ios_group.dart';

class ThemeIosPage extends StatelessWidget {
  const ThemeIosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeIosView();
  }
}

class ThemeIosView extends StatelessWidget {
  const ThemeIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.themes_title).tr(),
      leading: CupertinoNavigationBarBackButton(
        //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
        onPressed: () => Navigator.of(context).pop(),
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
