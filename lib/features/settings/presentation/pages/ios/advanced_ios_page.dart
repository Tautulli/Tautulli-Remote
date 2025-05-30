import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/advanced_ios_group.dart';
import '../../widgets/ios/groups/operations_ios_group.dart';

class AdvancedIosPage extends StatelessWidget {
  const AdvancedIosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdvancedIosView();
  }
}

class AdvancedIosView extends StatelessWidget {
  const AdvancedIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.advanced_title).tr(),
      leading: CupertinoNavigationBarBackButton(
        //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
        onPressed: () => Navigator.of(context).pop(),
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
