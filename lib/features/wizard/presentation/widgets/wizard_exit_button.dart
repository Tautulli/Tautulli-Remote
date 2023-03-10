import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../dependency_injection.dart' as di;
import '../../../settings/domain/usecases/settings.dart';

class WizardExitButton extends StatelessWidget {
  const WizardExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'exit',
      backgroundColor: Theme.of(context).colorScheme.error,
      child: const FaIcon(FontAwesomeIcons.xmark),
      onPressed: () async {
        await di.sl<Settings>().setWizardComplete(true);
        Navigator.of(context).maybePop();
      },
    );
  }
}
