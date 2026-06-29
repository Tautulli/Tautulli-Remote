import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/app_style.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleStylesGroup extends StatelessWidget {
  const CupertinoStyleStylesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return CupertinoStyleListSection(
          headerText: LocaleKeys.styles_title.tr(),
          children: [
            CupertinoStyleNotchedCupertinoListTile(
              leading: const FaIcon(
                FontAwesomeIcons.android,
                color: ThemeHelper.cupertinoListTileIconColor,
                size: 21.3,
              ),
              titleText: 'Material',
              trailing: state.appSettings.appStyle == AppStyle.material
                  ? const Icon(CupertinoIcons.checkmark_alt)
                  : null,
              onTap: () {
                context.read<SettingsBloc>().add(
                  const SettingsUpdateAppStyle(AppStyle.material),
                );
              },
            ),
            CupertinoStyleNotchedCupertinoListTile(
              leading: const FaIcon(
                FontAwesomeIcons.apple,
                color: ThemeHelper.cupertinoListTileIconColor,
                size: 26,
              ),
              titleText: 'Cupertino',
              trailing: state.appSettings.appStyle == AppStyle.cupertino
                  ? const Icon(CupertinoIcons.checkmark_alt)
                  : null,
              onTap: () {
                context.read<SettingsBloc>().add(
                  const SettingsUpdateAppStyle(AppStyle.cupertino),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
