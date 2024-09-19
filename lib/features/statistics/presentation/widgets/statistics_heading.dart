import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/string_helper.dart';
import '../../../../core/widgets/heading.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/statistic_model.dart';

class StatisticsHeading extends StatelessWidget {
  final StatisticModel stat;
  final Function()? onTap;

  const StatisticsHeading({
    super.key,
    required this.stat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: Heading(
                    text: StringHelper.mapStatIdTypeToString(stat.statIdType),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (onTap != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(LocaleKeys.more_title).tr(),
                      const Gap(4),
                      FaIcon(
                        FontAwesomeIcons.angleRight,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
