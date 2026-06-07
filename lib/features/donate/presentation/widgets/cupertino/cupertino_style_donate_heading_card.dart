import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleDonateHeadingCard extends StatelessWidget {
  const CupertinoStyleDonateHeadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleCard(
      child: Padding(
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
      ),
    );
  }
}
