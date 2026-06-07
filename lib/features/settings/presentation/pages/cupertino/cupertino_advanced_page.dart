import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/cupertino/groups/cupertino_style_advanced_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_operations_group.dart';

class CupertinoAdvancedPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoAdvancedPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAdvancedView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoAdvancedView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoAdvancedView({
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
          CupertinoStyleAdvancedGroup(),
          CupertinoStyleOperationsGroup(),
        ],
      ),
    );
  }
}
