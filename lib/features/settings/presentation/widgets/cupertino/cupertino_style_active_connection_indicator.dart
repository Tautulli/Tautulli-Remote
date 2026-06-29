import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleActiveConnectionIndicator extends StatelessWidget {
  const CupertinoStyleActiveConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return GestureDetector(
      child: const SizedBox(
        width: 35,
        height: 35,
        child: Center(
          child: Icon(
            CupertinoIcons.circle_fill,
            size: 16,
          ),
        ),
      ),
      onTap: () async => await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text(LocaleKeys.active_connection_title).tr(),
          content: const Text(LocaleKeys.active_connection_content).tr(),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(LocaleKeys.close_title).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
