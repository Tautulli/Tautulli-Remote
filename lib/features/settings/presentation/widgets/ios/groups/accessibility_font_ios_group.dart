import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class AccessibilityFontIosGroup extends StatelessWidget {
  const AccessibilityFontIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.font_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final useAtkinsonHyperlegible = state.appSettings.useAtkinsonHyperlegible;

            return CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.font,
                color: ThemeHelper.cupertinoListTileIconColor(),
                size: 23,
              ),
              trailing: CupertinoSwitch(
                value: useAtkinsonHyperlegible,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateUseAtkinsonHyperlegible(value),
                      );
                },
              ),
              title: const Text(
                'Atkinson Hyperlegible',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        )
      ],
    );
  }
}
