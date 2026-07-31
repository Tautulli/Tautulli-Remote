import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../push/presentation/bloc/push_privacy_bloc.dart';
import '../../../../../push/presentation/bloc/push_sub_bloc.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardFinishButton extends StatelessWidget {
  const CupertinoStyleWizardFinishButton({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, wizardState) {
        wizardState as WizardInitial;

        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: () async {
            final settingsBloc = context.read<SettingsBloc>();

            settingsBloc.add(const SettingsUpdateWizardComplete(true));

            if (wizardState.notificationsAllowed) {
              final pushPrivacyBloc = context.read<PushPrivacyBloc>();
              final pushSubBloc = context.read<PushSubBloc>();

              pushPrivacyBloc.add(
                PushPrivacyGrant(),
              );
              // Re-read the subscription once consent lands, so the settings
              // banner does not still claim the device is unregistered.
              await pushPrivacyBloc.stream.firstWhere((s) => s is! PushPrivacyInitial);
              pushSubBloc.add(PushSubCheck());
            }

            CupertinoSheetRoute.popSheet(context);
          },
          child: const Text(LocaleKeys.finish_title).tr(),
        );
      },
    );
  }
}
