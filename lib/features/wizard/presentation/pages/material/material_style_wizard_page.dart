import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/base/tautulli_logo_title.dart';
import '../../bloc/wizard_bloc.dart';
import '../../widgets/material/material_style_wizard_accessibility.dart';
import '../../widgets/material/material_style_wizard_closing.dart';
import '../../widgets/material/material_style_wizard_onesignal.dart';
import '../../widgets/material/dialogs/material_style_wizard_quit_dialog.dart';
import '../../widgets/material/material_style_wizard_servers.dart';
import '../../widgets/material/material_style_wizard_themes.dart';

class MaterialStyleWizardPage extends StatelessWidget {
  const MaterialStyleWizardPage({super.key});

  static const routeName = '/wizard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardBloc(),
      child: const MaterialStyleWizardView(),
    );
  }
}

class MaterialStyleWizardView extends StatelessWidget {
  const MaterialStyleWizardView({super.key});

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
                return const MaterialStyleWizardQuitDialog();
              },
            );

            if (shouldPop ?? false) {
              navigator.pop();
            }
          },
          child: MaterialStylePageBody(
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
                                    return const MaterialStyleWizardServers();
                                  }
                                  if (state.activeStep == 1) {
                                    return const MaterialStyleWizardOneSignal();
                                  }
                                  if (state.activeStep == 2) {
                                    return const MaterialStyleWizardThemes();
                                  }
                                  if (state.activeStep == 3) {
                                    return const MaterialStyleWizardAccessibility();
                                  }
                                  if (state.activeStep == 4) {
                                    return const MaterialStyleWizardClosing();
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
