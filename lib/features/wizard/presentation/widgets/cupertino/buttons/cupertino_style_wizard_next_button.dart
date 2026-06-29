import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardNextButton extends StatelessWidget {
  final bool isDisabled;

  const CupertinoStyleWizardNextButton({
    super.key,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onPressed: isDisabled ? null : () => context.read<WizardBloc>().add(WizardNext()),
      child: const Text(LocaleKeys.next_title).tr(),
    );
  }
}
