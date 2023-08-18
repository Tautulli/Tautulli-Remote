import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/types/theme_type.dart';
import '../../../../../core/widgets/custom_radio_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';

class ThemesGroup extends StatelessWidget {
  const ThemesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return ListTileGroup(
          heading: LocaleKeys.themes_title.tr(),
          listTiles: [
            CustomRadioListTile(
              leading: WebsafeSvg.asset(
                'assets/logos/logo_flat.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
                height: 35,
              ),
              title: 'Tautulli',
              subtitle: LocaleKeys.tautulli_theme_subtitle.tr(),
              value: ThemeType.tautulli,
              groupValue: state.appSettings.theme,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      SettingsUpdateTheme(value as ThemeType),
                    );
              },
            ),
            CustomRadioListTile(
              leading: FaIcon(
                FontAwesomeIcons.swatchbook,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.dynamic_title.tr(),
              subtitle: LocaleKeys.dynamic_theme_subtitle.tr(),
              value: ThemeType.dynamic,
              groupValue: state.appSettings.theme,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      SettingsUpdateTheme(value as ThemeType),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
