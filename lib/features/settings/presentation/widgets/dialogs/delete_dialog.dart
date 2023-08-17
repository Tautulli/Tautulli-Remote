import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../translations/locale_keys.g.dart';

class DeleteDialog extends StatelessWidget {
  final Widget title;

  const DeleteDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text(LocaleKeys.cancel_title).tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(LocaleKeys.delete_title).tr(),
        ),
      ],
    );
  }
}
