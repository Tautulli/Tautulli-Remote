import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/wizard_bloc.dart';

class WizardNextButton extends StatelessWidget {
  final bool isDisabled;

  const WizardNextButton({
    super.key,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'next',
      backgroundColor: isDisabled ? Theme.of(context).disabledColor : null,
      foregroundColor: isDisabled ? Theme.of(context).disabledColor : null,
      onPressed: isDisabled
          ? null
          : () {
              context.read<WizardBloc>().add(WizardNext());
            },
      child: const FaIcon(FontAwesomeIcons.arrowRight),
    );
  }
}
