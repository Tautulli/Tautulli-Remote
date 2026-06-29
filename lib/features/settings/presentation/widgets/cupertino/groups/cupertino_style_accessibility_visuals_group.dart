import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleAccessibilityVisualsGroup extends StatelessWidget {
  final bool isWizard;

  const CupertinoStyleAccessibilityVisualsGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleListSection(
      margin: isWizard ? const EdgeInsets.only(bottom: 10) : null,
      headerText: isWizard ? null : LocaleKeys.visuals_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CupertinoStyleNotchedCupertinoListTile(
              leading: const Icon(
                CupertinoIcons.photo_fill,
                color: ThemeHelper.cupertinoListTileIconColor,
              ),
              trailing: CupertinoSwitch(
                value: state.appSettings.disableImageBackgrounds,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdateDisableImageBackgrounds(value),
                  );
                },
              ),
              titleText: LocaleKeys.disable_image_backgrounds_title.tr(),
            );
          },
        ),
      ],
    );
  }
}
