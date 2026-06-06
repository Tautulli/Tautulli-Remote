import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/theme_type.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ThemesIosGroup extends StatelessWidget {
  final bool isWizard;

  const ThemesIosGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return CustomCupertinoListSection(
          margin: isWizard ? const EdgeInsets.only(bottom: 10) : null,
          headerText: isWizard ? null : LocaleKeys.themes_title.tr(),
          children: [
            CustomNotchedCupertinoListTile(
              leading: WebsafeSvg.asset(
                'assets/logos/logo_flat.svg',
                colorFilter: ColorFilter.mode(
                  ThemeHelper.cupertinoListTileIconColor(),
                  BlendMode.srcIn,
                ),
                height: 30,
              ),
              trailing: state.appSettings.theme == ThemeType.tautulli ? const Icon(CupertinoIcons.checkmark_alt) : null,
              titleText: 'Tautulli',
              subtitleText: LocaleKeys.tautulli_theme_subtitle.tr(),
              onTap: () {
                context.read<SettingsBloc>().add(
                  const SettingsUpdateTheme(ThemeType.tautulli),
                );
              },
            ),
            CustomNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.color_filter,
                color: ThemeHelper.cupertinoListTileIconColor(),
                size: 32,
              ),
              trailing: state.appSettings.theme == ThemeType.dynamic ? const Icon(CupertinoIcons.checkmark_alt) : null,
              titleText: LocaleKeys.dynamic_title.tr(),
              subtitleText: LocaleKeys.dynamic_theme_subtitle.tr(),
              onTap: () {
                context.read<SettingsBloc>().add(
                  const SettingsUpdateTheme(ThemeType.dynamic),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
