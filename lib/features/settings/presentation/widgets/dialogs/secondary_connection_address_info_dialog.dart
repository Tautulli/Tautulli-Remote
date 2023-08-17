import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../translations/locale_keys.g.dart';

class SecondaryConnectionAddressInfoDialog extends StatelessWidget {
  const SecondaryConnectionAddressInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        LocaleKeys.secondary_connection_address_title,
      ).tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            LocaleKeys.secondary_connection_address_explanation_one,
          ).tr(),
          const Gap(8),
          const Text(
            LocaleKeys.secondary_connection_address_explanation_two,
          ).tr(),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text(LocaleKeys.close_title).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
