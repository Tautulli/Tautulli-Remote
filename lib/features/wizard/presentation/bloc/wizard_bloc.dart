import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wizard_event.dart';
part 'wizard_state.dart';

class WizardBloc extends Bloc<WizardEvent, WizardState> {
  WizardBloc()
    : super(
        const WizardInitial(
          activeStep: 0,
          notificationsAllowed: false,
          notificationsSkipped: false,
          stepCount: 5,
          serversSkipped: false,
        ),
      ) {
    on<WizardNext>((event, emit) => _onWizardNext(event, emit));
    on<WizardPrevious>((event, emit) => _onWizardPrevious(event, emit));
    on<WizardSkipNotifications>(
      (event, emit) => _onWizardSkipNotifications(event, emit),
    );
    on<WizardSkipServers>(
      (event, emit) => _onWizardSkipServers(event, emit),
    );
    on<WizardToggleNotifications>(
      (event, emit) => _onWizardToggleNotifications(event, emit),
    );
  }

  void _onWizardNext(
    WizardNext event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    if (currentState.activeStep < currentState.stepCount - 1) {
      emit(
        currentState.copyWith(activeStep: currentState.activeStep + 1),
      );
    }
  }

  void _onWizardPrevious(
    WizardPrevious event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    if (currentState.activeStep > 0) {
      emit(
        currentState.copyWith(activeStep: currentState.activeStep - 1),
      );
    }
  }

  void _onWizardSkipNotifications(
    WizardSkipNotifications event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    emit(
      currentState.copyWith(
        activeStep: currentState.activeStep + 1,
        notificationsSkipped: true,
      ),
    );
  }

  void _onWizardSkipServers(
    WizardSkipServers event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    emit(
      currentState.copyWith(
        activeStep: currentState.activeStep + 1,
        serversSkipped: true,
      ),
    );
  }

  void _onWizardToggleNotifications(
    WizardToggleNotifications event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    emit(
      currentState.copyWith(notificationsAllowed: !currentState.notificationsAllowed),
    );
  }
}
