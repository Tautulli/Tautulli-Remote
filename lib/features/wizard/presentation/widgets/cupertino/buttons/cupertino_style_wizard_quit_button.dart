import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../dialogs/cupertino_style_wizard_quit_dialog.dart';

class CupertinoStyleWizardQuitButton extends StatelessWidget {
  const CupertinoStyleWizardQuitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(
        LocaleKeys.quit_title,
        style: TextStyle(
          color: CupertinoColors.destructiveRed,
        ),
      ).tr(),
      onPressed: () async {
        bool result = await showCupertinoDialog(
          context: context,
          builder: (context) => const CupertinoStyleWizardQuitDialog(),
        );

        if (result) {
          context.read<SettingsBloc>().add(const SettingsUpdateWizardComplete(true));
          CupertinoSheetRoute.popSheet(context);
        }
      },
    );
  }
}
