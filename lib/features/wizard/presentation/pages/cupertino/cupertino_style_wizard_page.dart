import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/wizard_skip_type.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../core/widgets/tautulli_logo_title.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/wizard_bloc.dart';
import '../../widgets/cupertino/cupertino_style_wizard_accessibility.dart';
import '../../widgets/cupertino/cupertino_style_wizard_appearance.dart';
import '../../widgets/cupertino/buttons/cupertino_style_wizard_back_button.dart';
import '../../widgets/cupertino/cupertino_style_wizard_closing.dart';
import '../../widgets/cupertino/buttons/cupertino_style_wizard_finish_button.dart';
import '../../widgets/cupertino/cupertino_style_wizard_stepper.dart';
import '../../widgets/cupertino/buttons/cupertino_style_wizard_next_button.dart';
import '../../widgets/cupertino/cupertino_style_wizard_onesignal.dart';
import '../../widgets/cupertino/buttons/cupertino_style_wizard_quit_button.dart';
import '../../widgets/cupertino/cupertino_style_wizard_servers.dart';
import '../../widgets/cupertino/buttons/cupertino_style_wizard_skip_button.dart';

// Ignoring const as consts prevents the wizard from changing when the language is changed
// ignore_for_file: prefer_const_constructors

class CupertinoStyleWizardPage extends StatelessWidget {
  const CupertinoStyleWizardPage({super.key});

  static const routeName = '/wizard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardBloc(),
      child: CupertinoStyleWizardView(),
    );
  }
}

class CupertinoStyleWizardView extends StatelessWidget {
  const CupertinoStyleWizardView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, wizardState) {
        context.locale; // Ensures bloc updates when locale is changed
        wizardState as WizardInitial;

        return CupertinoStylePageScaffold(
          showBackButton: false,
          leading: _WizardLeftIosAction(activeStep: wizardState.activeStep),
          middle: CupertinoStyleWizardStepper(
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
                            return CupertinoStyleWizardServers();
                          case 1:
                            return CupertinoStyleWizardOnesignal();
                          case 2:
                            return CupertinoStyleWizardAppearance();
                          case 3:
                            return CupertinoStyleWizardAccessibility();
                          case 4:
                            return CupertinoStyleWizardClosing();
                          default:
                            return Container(
                              color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                              child: CupertinoStyleStatusPage(
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
      return const CupertinoStyleWizardQuitButton();
    }

    return const CupertinoStyleWizardBackButton();
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
          return const CupertinoStyleWizardSkipButton(wizardSkipType: WizardSkipType.servers);
        } else if (activeStep == 1 && !(oneSignalSkipped || oneSignalAllowed)) {
          return const CupertinoStyleWizardSkipButton(wizardSkipType: WizardSkipType.onesignal);
        } else if (activeStep == stepCount - 1) {
          return const CupertinoStyleWizardFinishButton();
        }

        return const CupertinoStyleWizardNextButton();
      },
    );
  }
}
