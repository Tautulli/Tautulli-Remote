import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../widgets/advanced_settings_group.dart';
import '../widgets/operations_group.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdvancedSettingsView();
  }
}

class AdvancedSettingsView extends StatelessWidget {
  const AdvancedSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Settings'),
      ),
      body: PageBody(
        child: ListView(
          children: const [
            AdvancedSettingsGroup(),
            Gap(8),
            OperationsGroup(),
          ],
        ),
      ),
    );
  }
}
