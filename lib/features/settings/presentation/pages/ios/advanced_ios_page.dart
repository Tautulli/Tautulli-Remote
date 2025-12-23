import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/advanced_ios_group.dart';
import '../../widgets/ios/groups/operations_ios_group.dart';

class AdvancedIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AdvancedIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class AdvancedIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AdvancedIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.advanced_title).tr(),
      child: ListView(
        children: const [
          AdvancedIosGroup(),
          OperationsIosGroup(),
        ],
      ),
    );
  }
}
