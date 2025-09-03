import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/bullet_list.dart';
import '../../../../../core/widgets/ios/cupertino_card.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../translations/locale_keys.g.dart';

class ServerRegistrationIosStepOne extends StatelessWidget {
  const ServerRegistrationIosStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCupertinoListSection(
          headerText: '${LocaleKeys.step_title.tr()} 1',
        ),
        CupertinoCard(
          horizontalPadding: 20,
          child: Padding(
            padding: const EdgeInsetsGeometry.all(8),
            child: BulletList(
              listItems: [
                LocaleKeys.server_registration_bullet_one.tr(),
                LocaleKeys.server_registration_bullet_two.tr(),
                LocaleKeys.server_registration_bullet_three.tr(),
                LocaleKeys.server_registration_bullet_four.tr(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
