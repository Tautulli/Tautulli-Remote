import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../translations/locale_keys.g.dart';

class IosBottomSheetCancelButton extends StatelessWidget {
  const IosBottomSheetCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(LocaleKeys.cancel_title).tr(),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
