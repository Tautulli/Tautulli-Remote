import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../translations/locale_keys.g.dart';
import '../bloc/wizard_bloc.dart';
import 'wizard_skip_dialog.dart';

enum SkipType {
  servers,
  onesignal,
}

class WizardSkipButton extends StatelessWidget {
  final SkipType skipType;

  const WizardSkipButton({
    super.key,
    required this.skipType,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'skip',
      child: const FaIcon(FontAwesomeIcons.forward),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => WizardSkipDialog(
            message: skipType == SkipType.servers ? LocaleKeys.wizard_skip_dialog_message_servers.tr() : LocaleKeys.wizard_skip_dialog_message_onesignal.tr(),
          ),
        );

        if (result) {
          if (skipType == SkipType.servers) {
            context.read<WizardBloc>().add(WizardSkipServers());
          } else {
            context.read<WizardBloc>().add(WizardSkipOneSignal());
          }
        }
      },
    );
  }
}
