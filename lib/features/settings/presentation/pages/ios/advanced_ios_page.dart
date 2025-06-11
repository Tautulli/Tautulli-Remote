import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/advanced_ios_group.dart';
import '../../widgets/ios/groups/operations_ios_group.dart';

class AdvancedIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const AdvancedIosPage({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedIosView(
      previousPageTitle: previousPageTitle,
    );
  }
}

class AdvancedIosView extends StatelessWidget {
  final String? previousPageTitle;

  const AdvancedIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.advanced_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: previousPageTitle,
      ),
      child: ListView(
        children: const [
          AdvancedIosGroup(),
          OperationsIosGroup(),
        ],
      ),
    );
  }
}
