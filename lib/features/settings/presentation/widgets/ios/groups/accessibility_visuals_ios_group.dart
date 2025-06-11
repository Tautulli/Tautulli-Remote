import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class AccessibilityVisualsIosGroup extends StatelessWidget {
  const AccessibilityVisualsIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.theme_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CustomNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.photo_fill,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              trailing: CupertinoSwitch(
                value: state.appSettings.disableImageBackgrounds,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateDisableImageBackgrounds(value),
                      );
                },
              ),
              title: const Text(
                LocaleKeys.disable_image_backgrounds_title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(),
            );
          },
        )
      ],
    );
  }
}
