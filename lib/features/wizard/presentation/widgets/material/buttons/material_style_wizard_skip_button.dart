import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/types/wizard_skip_type.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/wizard_bloc.dart';
import '../dialogs/material_style_wizard_skip_dialog.dart';

class MaterialStyleWizardSkipButton extends StatelessWidget {
  final WizardSkipType wizardSkipType;

  const MaterialStyleWizardSkipButton({
    super.key,
    required this.wizardSkipType,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'skip',
      child: const FaIcon(FontAwesomeIcons.forward),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => MaterialStyleWizardSkipDialog(
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
