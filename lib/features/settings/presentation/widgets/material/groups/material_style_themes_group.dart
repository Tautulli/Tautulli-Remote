import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../core/types/theme_type.dart';
import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleThemesGroup extends StatelessWidget {
  const MaterialStyleThemesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;
        final theme = state.appSettings.theme;

        return MaterialStyleListTileGroup(
          heading: LocaleKeys.themes_title.tr(),
          listTiles: [
            MaterialStyleListTile(
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
              trailing: theme == ThemeType.tautulli
                  ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => context.read<SettingsBloc>().add(const SettingsUpdateTheme(ThemeType.tautulli)),
            ),
            MaterialStyleListTile(
              leading: FaIcon(
                FontAwesomeIcons.swatchbook,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.dynamic_title.tr(),
              subtitle: LocaleKeys.dynamic_theme_subtitle.tr(),
              trailing: theme == ThemeType.dynamic
                  ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => context.read<SettingsBloc>().add(const SettingsUpdateTheme(ThemeType.dynamic)),
            ),
          ],
        );
      },
    );
  }
}
