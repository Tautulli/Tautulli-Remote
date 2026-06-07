import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/heading_ios.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/statistic_model.dart';

class CupertinoStyleStatisticsHeading extends StatelessWidget {
  final StatisticModel stat;
  final Function()? onTap;

  const CupertinoStyleStatisticsHeading({
    super.key,
    required this.stat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: HeadingIos(
                text: StringHelper.mapStatIdTypeToString(stat.statIdType),
                color: ThemeHelper.cupertinoStandardTextColor(),
              ),
            ),
            if (onTap != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(LocaleKeys.more_title).tr(),
                  const Gap(4),
                  Icon(
                    CupertinoIcons.right_chevron,
                    size: 16,
                    color: ThemeHelper.cupertinoCardIconColor(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
