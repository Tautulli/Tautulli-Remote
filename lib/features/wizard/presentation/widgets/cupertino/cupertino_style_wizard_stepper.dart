import 'package:flutter/cupertino.dart';
import 'package:im_stepper/stepper.dart';

class CupertinoStyleWizardStepper extends StatelessWidget {
  final int stepCount;
  final int activeStep;

  const CupertinoStyleWizardStepper({
    super.key,
    required this.stepCount,
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    return DotStepper(
      dotCount: stepCount,
      activeStep: activeStep,
      dotRadius: 6,
      spacing: 8,
      indicatorDecoration: IndicatorDecoration(
        color: CupertinoTheme.of(context).primaryColor,
        strokeWidth: 0,
      ),
      fixedDotDecoration: const FixedDotDecoration(
        strokeWidth: 0,
      ),
      tappingEnabled: false,
    );
  }
}
