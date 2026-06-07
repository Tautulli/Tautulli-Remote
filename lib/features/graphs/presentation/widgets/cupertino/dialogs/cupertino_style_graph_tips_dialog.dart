import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleGraphTipsDialog extends StatelessWidget {
  const CupertinoStyleGraphTipsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.tips_title).tr(),
      content: const Text(LocaleKeys.graphs_tips_dialog_content).tr(),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text(LocaleKeys.close_title).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
