import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleUsersLoadIssueDialog extends StatelessWidget {
  const CupertinoStyleUsersLoadIssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      //TODO: Add translation strings
      title: const Text('Error'),
      content: const Text('Failed to fetch the users list.'),
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
