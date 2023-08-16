import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';

import '../bloc/wizard_bloc.dart';

class WizardStepper extends StatelessWidget {
  final Widget leftAction;
  final Widget rightAction;

  const WizardStepper({
    super.key,
    required this.leftAction,
    required this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, state) {
        state as WizardInitial;

        return Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftAction,
              DotStepper(
                dotCount: state.stepCount,
                activeStep: state.activeStep,
                dotRadius: 6,
                spacing: 8,
                indicatorDecoration: IndicatorDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 0,
                ),
                fixedDotDecoration: const FixedDotDecoration(
                  strokeWidth: 0,
                ),
                tappingEnabled: false,
              ),
              rightAction,
            ],
          ),
        );
      },
    );
  }
}
