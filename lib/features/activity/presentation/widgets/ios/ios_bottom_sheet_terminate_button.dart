import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../translations/locale_keys.g.dart';

class IosBottomSheetTerminateButton extends StatelessWidget {
  const IosBottomSheetTerminateButton({super.key});

  @override
  Widget build(BuildContext context) {
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
