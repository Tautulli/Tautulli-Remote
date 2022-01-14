import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: ListView(
          children: const [
            AdvancedSettingsGroup(),
            OperationsGroup(),
          ],
        ),
      ),
    );
  }
}
