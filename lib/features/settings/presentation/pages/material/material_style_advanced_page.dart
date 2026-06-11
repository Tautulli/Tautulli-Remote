import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/groups/material_style_advanced_group.dart';
import '../../widgets/material/groups/material_style_operations_group.dart';

class MaterialStyleAdvancedPage extends StatelessWidget {
  const MaterialStyleAdvancedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleAdvancedView();
  }
}

class MaterialStyleAdvancedView extends StatelessWidget {
  const MaterialStyleAdvancedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.advanced_title).tr(),
      ),
      body: MaterialStylePageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            MaterialStyleAdvancedGroup(),
            Gap(8),
            MaterialStyleOperationsGroup(),
          ],
        ),
      ),
    );
  }
}
