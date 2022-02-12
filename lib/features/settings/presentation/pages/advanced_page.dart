import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../widgets/groups/advanced_group.dart';
import '../widgets/groups/operations_group.dart';

class AdvancedPage extends StatelessWidget {
  const AdvancedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdvancedView();
  }
}

class AdvancedView extends StatelessWidget {
  const AdvancedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced'),
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
