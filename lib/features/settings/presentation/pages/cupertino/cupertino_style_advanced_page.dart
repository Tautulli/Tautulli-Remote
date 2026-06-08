import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/cupertino/groups/cupertino_style_advanced_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_operations_group.dart';

class CupertinoStyleAdvancedPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAdvancedPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleAdvancedView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleAdvancedView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAdvancedView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
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
