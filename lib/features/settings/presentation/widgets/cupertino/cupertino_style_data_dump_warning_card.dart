import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleDataDumpWarningCard extends StatelessWidget {
  const CupertinoStyleDataDumpWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleCard(
      tint: CupertinoColors.systemRed.darkColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const FaIcon(FontAwesomeIcons.triangleExclamation),
            const Gap(16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    LocaleKeys.data_dump_warning_line_1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(),
                  const Text(
                    LocaleKeys.data_dump_warning_line_2,
                    style: TextStyle(),
                  ).tr(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
