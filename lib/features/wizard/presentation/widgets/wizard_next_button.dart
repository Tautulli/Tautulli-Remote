import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/wizard_bloc.dart';

class WizardNextButton extends StatelessWidget {
  final bool isDisabled;

  const WizardNextButton({
    Key? key,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'next',
      backgroundColor: isDisabled ? Colors.grey : null,
      child: FaIcon(
        FontAwesomeIcons.arrowRight,
        color: isDisabled ? Colors.grey[350] : null,
      ),
      onPressed: isDisabled
          ? null
          : () {
              context.read<WizardBloc>().add(WizardNext());
            },
    );
  }
}
