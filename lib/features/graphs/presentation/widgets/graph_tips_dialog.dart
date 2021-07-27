import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';

class GraphTipsDialog extends StatelessWidget {
  const GraphTipsDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.general_tips).tr(),
      content: const Text(LocaleKeys.graphs_tips_dialog_content).tr(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.button_close).tr(),
        ),
      ],
    );
  }
}
