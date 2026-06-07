import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardFinishButton extends StatelessWidget {
  const CupertinoStyleWizardFinishButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, wizardState) {
        wizardState as WizardInitial;

        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: () async {
            final settingsBloc = context.read<SettingsBloc>();

            settingsBloc.add(const SettingsUpdateWizardComplete(true));

            if (wizardState.oneSignalAllowed) {
              context.read<OneSignalPrivacyBloc>().add(
                OneSignalPrivacyGrant(
                  settingsBloc: settingsBloc,
                ),
              );
            }

            CupertinoSheetRoute.popSheet(context);
          },
          //TODO: Needs translation string
          child: const Text('Finish'),
        );
      },
    );
  }
}
