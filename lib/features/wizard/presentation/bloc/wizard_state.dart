part of 'wizard_bloc.dart';

abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object> get props => [];
}

class WizardInitial extends WizardState {
  final int activeStep;
  final bool notificationsSkipped;
  final bool notificationsAllowed;
  final int stepCount;
  final bool serversSkipped;

  const WizardInitial({
    required this.activeStep,
    required this.notificationsSkipped,
    required this.notificationsAllowed,
    required this.stepCount,
    required this.serversSkipped,
  });

  WizardInitial copyWith({
    final int? activeStep,
    final bool? notificationsSkipped,
    final bool? notificationsAllowed,
    final int? stepCount,
    final bool? serversSkipped,
  }) {
    return WizardInitial(
      activeStep: activeStep ?? this.activeStep,
      notificationsSkipped: notificationsSkipped ?? this.notificationsSkipped,
      notificationsAllowed: notificationsAllowed ?? this.notificationsAllowed,
      stepCount: stepCount ?? this.stepCount,
      serversSkipped: serversSkipped ?? this.serversSkipped,
    );
  }

  @override
  List<Object> get props => [
        activeStep,
        notificationsSkipped,
        notificationsAllowed,
        stepCount,
        serversSkipped,
      ];
}
