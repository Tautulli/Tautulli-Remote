import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
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

            if (wizardState.oneSignalAllowed) {
              context.read<OneSignalPrivacyBloc>().add(
                OneSignalPrivacyGrant(),
              );
            }

            CupertinoSheetRoute.popSheet(context);
          },
          child: const Text(LocaleKeys.finish_title).tr(),
        );
      },
    );
  }
}
