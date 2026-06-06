import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/wizard_skip_type.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../core/widgets/tautulli_logo_title.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/wizard_bloc.dart';
import '../../widgets/ios/wizard_accessibility_ios.dart';
import '../../widgets/ios/wizard_appearance_ios.dart';
import '../../widgets/ios/wizard_back_ios_button.dart';
import '../../widgets/ios/wizard_closing_ios.dart';
import '../../widgets/ios/wizard_finish_ios_button.dart';
import '../../widgets/ios/wizard_ios_stepper.dart';
import '../../widgets/ios/wizard_next_ios_button.dart';
import '../../widgets/ios/wizard_onesignal_ios.dart';
import '../../widgets/ios/wizard_quit_ios_button.dart';
import '../../widgets/ios/wizard_servers_ios.dart';
import '../../widgets/ios/wizard_skip_ios_button.dart';

// Ignoring const as consts prevents the wizard from changing when the language is changed
// ignore_for_file: prefer_const_constructors

class WizardIosPage extends StatelessWidget {
  const WizardIosPage({super.key});

  static const routeName = '/wizard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardBloc(),
      child: WizardIosView(),
    );
  }
}

class WizardIosView extends StatelessWidget {
  const WizardIosView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, wizardState) {
        context.locale; // Ensures bloc updates when locale is changed
        wizardState as WizardInitial;

        return PageScaffoldCupertino(
          showBackButton: false,
          leading: _WizardLeftIosAction(activeStep: wizardState.activeStep),
          middle: WizardIosStepper(
            stepCount: wizardState.stepCount,
            activeStep: wizardState.activeStep,
          ),
          trailing: _WizardRightIosAction(
            activeStep: wizardState.activeStep,
            stepCount: wizardState.stepCount,
            serversSkipped: wizardState.serversSkipped,
            oneSignalSkipped: wizardState.oneSignalSkipped,
            oneSignalAllowed: wizardState.oneSignalAllowed,
          ),
          child: CupertinoScrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TautulliLogoTitle(),
                    const Gap(16),
                    Builder(
                      builder: (context) {
                        switch (wizardState.activeStep) {
                          case 0:
                            return WizardServersIos();
                          case 1:
                            return WizardOnesignalIos();
                          case 2:
                            return WizardAppearanceIos();
                          case 3:
                            return WizardAccessibilityIos();
                          case 4:
                            return WizardClosingIos();
                          default:
                            return Container(
                              color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                              child: StatusIosPage(
                                //TODO: Needs translation strings
                                message: 'Wizard Error',
                                suggestion:
                                    'Something went wrong. Please report this and use the button to exit and setup manually.',
                                action: CupertinoButton.filled(
                                  child: const Text('Exit Wizard'),
                                  onPressed: () {
                                    context.read<SettingsBloc>().add(const SettingsUpdateWizardComplete(true));
                                    CupertinoSheetRoute.popSheet(context);
                                  },
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WizardLeftIosAction extends StatelessWidget {
  final int activeStep;

  const _WizardLeftIosAction({
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    if (activeStep == 0) {
      return const WizardQuitIosButton();
    }

    return const WizardBackIosButton();
  }
}

class _WizardRightIosAction extends StatelessWidget {
  final int activeStep;
  final int stepCount;
  final bool serversSkipped;
  final bool oneSignalSkipped;
  final bool oneSignalAllowed;

  const _WizardRightIosAction({
    required this.activeStep,
    required this.stepCount,
    required this.serversSkipped,
    required this.oneSignalSkipped,
    required this.oneSignalAllowed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        if (activeStep == 0 && (settingsState.serverList.isEmpty && !serversSkipped)) {
          return const WizardSkipIosButton(wizardSkipType: WizardSkipType.servers);
        } else if (activeStep == 1 && !(oneSignalSkipped || oneSignalAllowed)) {
          return const WizardSkipIosButton(wizardSkipType: WizardSkipType.onesignal);
        } else if (activeStep == stepCount - 1) {
          return const WizardFinishIosButton();
        }

        return const WizardNextIosButton();
      },
    );
  }
}
