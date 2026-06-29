import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleUsersLoadIssueDialog extends StatelessWidget {
  const CupertinoStyleUsersLoadIssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.error_title).tr(),
      content: const Text(LocaleKeys.failed_users_fetch_message).tr(),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.close_title).tr(),
        ),
      ],
    );
  }
}
