import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleBottomSheetTerminateButton extends StatelessWidget {
  const CupertinoStyleBottomSheetTerminateButton({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(
        LocaleKeys.terminate_title,
        style: TextStyle(
          color: CupertinoColors.destructiveRed,
        ),
      ).tr(),
      onPressed: () => Navigator.of(context).pop(true),
    );
  }
}
