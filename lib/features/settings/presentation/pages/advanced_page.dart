import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/groups/advanced_group.dart';
import '../widgets/groups/operations_group.dart';

class AdvancedPage extends StatelessWidget {
  const AdvancedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdvancedView();
  }
}

class AdvancedView extends StatelessWidget {
  const AdvancedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.advanced_title).tr(),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            AdvancedGroup(),
            Gap(8),
            OperationsGroup(),
          ],
        ),
      ),
    );
  }
}
