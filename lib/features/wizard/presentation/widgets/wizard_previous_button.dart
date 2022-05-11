import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/wizard_bloc.dart';

class WizardPreviousButton extends StatelessWidget {
  const WizardPreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'previous',
      child: const FaIcon(
        FontAwesomeIcons.arrowLeft,
      ),
      onPressed: () {
        context.read<WizardBloc>().add(WizardPrevious());
      },
    );
  }
}
