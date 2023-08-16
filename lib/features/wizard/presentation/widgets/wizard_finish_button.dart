import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/wizard_bloc.dart';

class WizardFinishButton extends StatelessWidget {
  const WizardFinishButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, state) {
        state as WizardInitial;

        return FloatingActionButton(
          backgroundColor: Colors.green[700],
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          child: const FaIcon(
            FontAwesomeIcons.check,
          ),
          onPressed: () async {
            final settingsBloc = context.read<SettingsBloc>();

            settingsBloc.add(const SettingsUpdateWizardComplete(true));

            if (state.oneSignalAllowed) {
              context.read<OneSignalPrivacyBloc>().add(
                    OneSignalPrivacyGrant(
                      settingsBloc: settingsBloc,
                    ),
                  );
            }

            await Navigator.of(context).pushNamedAndRemoveUntil('/activity', (route) => false);
          },
        );
      },
    );
  }
}
