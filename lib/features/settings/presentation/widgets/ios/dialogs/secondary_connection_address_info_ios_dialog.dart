import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../../translations/locale_keys.g.dart';

class SecondaryConnectionAddressInfoIosDialog extends StatelessWidget {
  const SecondaryConnectionAddressInfoIosDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        LocaleKeys.secondary_connection_address_title,
      ).tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(8),
          const Text(LocaleKeys.secondary_connection_address_explanation_one).tr(),
          const Gap(8),
          const Text(LocaleKeys.secondary_connection_address_explanation_two).tr(),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.close_title).tr(),
        ),
      ],
    );
  }
}
