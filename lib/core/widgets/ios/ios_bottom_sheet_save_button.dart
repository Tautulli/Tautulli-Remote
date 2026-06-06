import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../translations/locale_keys.g.dart';

class IosBottomSheetSaveButton extends StatelessWidget {
  final Function()? onPressed;

  const IosBottomSheetSaveButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onPressed: onPressed,
      child: const Text(LocaleKeys.save_title).tr(),
    );
  }
}
