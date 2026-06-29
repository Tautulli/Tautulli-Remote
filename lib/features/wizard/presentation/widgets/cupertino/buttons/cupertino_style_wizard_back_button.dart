import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardBackButton extends StatelessWidget {
  const CupertinoStyleWizardBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onPressed: () => context.read<WizardBloc>().add(WizardPrevious()),
      child: const Text(LocaleKeys.back_title).tr(),
    );
  }
}
