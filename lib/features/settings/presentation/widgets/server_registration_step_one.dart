import 'package:flutter/material.dart';

import '../../../../core/widgets/bullet_list.dart';
import 'registration_instruction.dart';

class ServerRegistrationStepOne extends StatelessWidget {
  const ServerRegistrationStepOne({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RegistrationInstruction(
      heading: 'Step 1',
      child: BulletList(
        listItems: [
          'Open the Tautulli web interface on another device.',
          'Navigate to Settings > Tautulli Remote App.',
          "Select 'Register a new device'.",
          'Make sure the Tautulli Address is accessible from other devices.',
        ],
      ),
    );
  }
}
