import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/wizard_bloc.dart';

class WizardBackIosButton extends StatelessWidget {
  const WizardBackIosButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onPressed: () => context.read<WizardBloc>().add(WizardPrevious()),
      //TODO: Needs translation string
      child: const Text('Back'),
    );
  }
}
