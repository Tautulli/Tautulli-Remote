import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/bullet_list.dart';
import '../../../../../translations/locale_keys.g.dart';
import 'material_style_registration_instruction.dart';

class MaterialStyleServerRegistrationStepOne extends StatelessWidget {
  const MaterialStyleServerRegistrationStepOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleRegistrationInstruction(
      heading: '${LocaleKeys.step_title.tr()} 1',
      child: BulletList(
        listItems: [
          LocaleKeys.server_registration_bullet_one.tr(),
          LocaleKeys.server_registration_bullet_two.tr(),
          LocaleKeys.server_registration_bullet_three.tr(),
          LocaleKeys.server_registration_bullet_four.tr(),
        ],
      ),
    );
  }
}
