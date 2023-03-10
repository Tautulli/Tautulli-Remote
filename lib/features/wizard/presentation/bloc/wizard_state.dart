part of 'wizard_bloc.dart';

abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object> get props => [];
}

class WizardInitial extends WizardState {
  final int activeStep;
  final bool oneSignalSkipped;
  final bool oneSignalAllowed;
  final int stepCount;
  final bool serversSkipped;

  const WizardInitial({
    required this.activeStep,
    required this.oneSignalSkipped,
    required this.oneSignalAllowed,
    required this.stepCount,
    required this.serversSkipped,
  });

  WizardInitial copyWith({
    final int? activeStep,
    final bool? oneSignalSkipped,
    final bool? oneSignalAllowed,
    final int? stepCount,
    final bool? serversSkipped,
  }) {
    return WizardInitial(
      activeStep: activeStep ?? this.activeStep,
      oneSignalSkipped: oneSignalSkipped ?? this.oneSignalSkipped,
      oneSignalAllowed: oneSignalAllowed ?? this.oneSignalAllowed,
      stepCount: stepCount ?? this.stepCount,
      serversSkipped: serversSkipped ?? this.serversSkipped,
    );
  }

  @override
  List<Object> get props => [
        activeStep,
        oneSignalSkipped,
        oneSignalAllowed,
        stepCount,
        serversSkipped,
      ];
}
