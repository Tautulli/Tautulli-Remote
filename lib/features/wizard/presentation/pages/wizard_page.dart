import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/tautulli_logo_title.dart';
import '../bloc/wizard_bloc.dart';
import '../widgets/wizard_accessibility.dart';
import '../widgets/wizard_closing.dart';
import '../widgets/wizard_onesignal.dart';
import '../widgets/wizard_quit_dialog.dart';
import '../widgets/wizard_servers.dart';
import '../widgets/wizard_themes.dart';

class WizardPage extends StatelessWidget {
  const WizardPage({super.key});

  static const routeName = '/wizard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardBloc(),
      child: const WizardView(),
    );
  }
}

class WizardView extends StatelessWidget {
  const WizardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
      ),
      child: Scaffold(
        // Without the appbar the SystemUiOverlayStyle is not setting the
        // notification bar icons to white
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            forceMaterialTransparency: true,
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final NavigatorState navigator = Navigator.of(context);
            final bool? shouldPop = await showDialog(
              context: context,
              builder: (_) {
                return const WizardQuitDialog();
              },
            );

            if (shouldPop ?? false) {
              navigator.pop();
            }
          },
          child: PageBody(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const TautulliLogoTitle(),
                              const Gap(16),
                              BlocBuilder<WizardBloc, WizardState>(
                                builder: (context, state) {
                                  state as WizardInitial;

                                  if (state.activeStep == 0) {
                                    return const WizardServers();
                                  }
                                  if (state.activeStep == 1) {
                                    return const WizardOneSignal();
                                  }
                                  if (state.activeStep == 2) {
                                    return const WizardThemes();
                                  }
                                  if (state.activeStep == 3) {
                                    return const WizardAccessibility();
                                  }
                                  if (state.activeStep == 4) {
                                    return const WizardClosing();
                                  }

                                  return const SizedBox(height: 0, width: 0);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
