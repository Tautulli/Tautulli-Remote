import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardNextButton extends StatelessWidget {
  final bool isDisabled;

  const CupertinoStyleWizardNextButton({
    super.key,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onPressed: isDisabled ? null : () => context.read<WizardBloc>().add(WizardNext()),
      //TODO: Needs translation string
      child: const Text('Next'),
    );
  }
}
