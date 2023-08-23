import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WizardExitButton extends StatelessWidget {
  const WizardExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'exit',
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      child: const FaIcon(FontAwesomeIcons.xmark),
      onPressed: () async {
        Navigator.of(context).maybePop();
      },
    );
  }
}
