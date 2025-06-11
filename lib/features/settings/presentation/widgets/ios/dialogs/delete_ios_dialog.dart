import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class DeleteIosDialog extends StatelessWidget {
  final Widget title;

  const DeleteIosDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(LocaleKeys.delete_title).tr(),
        ),
      ],
    );
  }
}
