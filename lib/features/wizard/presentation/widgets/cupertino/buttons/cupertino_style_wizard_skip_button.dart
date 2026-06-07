import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/types/wizard_skip_type.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/wizard_bloc.dart';
import '../dialogs/cupertino_style_wizard_skip_dialog.dart';

class CupertinoStyleWizardSkipButton extends StatelessWidget {
  final WizardSkipType wizardSkipType;

  const CupertinoStyleWizardSkipButton({
    super.key,
    required this.wizardSkipType,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(
        LocaleKeys.skip_title,
      ).tr(),
      onPressed: () async {
        final result = await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoStyleWizardSkipDialog(
            message: wizardSkipType == WizardSkipType.servers
                ? LocaleKeys.wizard_skip_dialog_message_servers.tr()
                : LocaleKeys.wizard_skip_dialog_message_onesignal.tr(),
          ),
        );

        if (result) {
          if (wizardSkipType == WizardSkipType.servers) {
            context.read<WizardBloc>().add(WizardSkipServers());
          } else {
            context.read<WizardBloc>().add(WizardSkipOneSignal());
          }
        }
      },
    );
  }
}
