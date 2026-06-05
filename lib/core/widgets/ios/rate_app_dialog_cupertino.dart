import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../../translations/locale_keys.g.dart';
import '../../rate_app/rate_app.dart';

class RateAppDialogCupertino extends StatelessWidget {
  const RateAppDialogCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.rate_app_title).tr(),
      content: const Text(LocaleKeys.rate_app_message).tr(),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text(LocaleKeys.dont_ask_again_message).tr(),
          onPressed: () async {
            await rateApp.callEvent(RateMyAppEventType.noButtonPressed);
            Navigator.of(context).pop<RateMyAppDialogButton>(
              RateMyAppDialogButton.no,
            );
          },
        ),
        CupertinoDialogAction(
          child: const Text(LocaleKeys.later_title).tr(),
          onPressed: () async {
            await rateApp.callEvent(RateMyAppEventType.laterButtonPressed);
            Navigator.of(context).pop<RateMyAppDialogButton>(
              RateMyAppDialogButton.later,
            );
          },
        ),
        CupertinoDialogAction(
          child: const Text(LocaleKeys.review_title).tr(),
          onPressed: () async {
            await rateApp.launchStore();
            await rateApp.callEvent(RateMyAppEventType.rateButtonPressed);
            Navigator.of(context).pop<RateMyAppDialogButton>(
              RateMyAppDialogButton.rate,
            );
          },
        ),
      ],
    );
  }
}
