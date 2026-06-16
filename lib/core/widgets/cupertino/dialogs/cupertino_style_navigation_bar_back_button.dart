import 'package:flutter/cupertino.dart';

import '../../../helpers/theme_helper.dart';

class CupertinoStyleNavigationBarBackButton extends StatelessWidget {
  final String? previousPageTitle;
  final Future<void> Function()? onBeforePop;

  const CupertinoStyleNavigationBarBackButton({
    super.key,
    this.previousPageTitle,
    this.onBeforePop,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBarBackButton(
      //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
      previousPageTitle: previousPageTitle,
      onPressed: () async {
        await onBeforePop?.call();
        if (context.mounted) Navigator.of(context).pop();
      },
      color: ThemeHelper.cupertinoNavigationBarItemColor,
    );
  }
}
