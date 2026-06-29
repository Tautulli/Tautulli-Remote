import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleHelpTranslateHeadingCard extends StatelessWidget {
  const CupertinoStyleHelpTranslateHeadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleCard(
      horizontalPadding: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              LocaleKeys.help_translate_heading_card_title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            const Gap(8),
            const Text(
              LocaleKeys.help_translate_heading_card_content,
              textAlign: TextAlign.center,
            ).tr(),
          ],
        ),
      ),
    );
  }
}
