import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../../translations/locale_keys.g.dart';

class DonateHeadingCardContent extends StatelessWidget {
  const DonateHeadingCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            LocaleKeys.donate_heading_card_title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ).tr(),
          const Gap(8),
          const Text(
            LocaleKeys.donate_heading_card_content,
            textAlign: TextAlign.center,
          ).tr(),
        ],
      ),
    );
  }
}
