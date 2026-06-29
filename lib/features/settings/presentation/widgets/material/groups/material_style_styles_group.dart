import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/types/app_style.dart';
import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleStylesGroup extends StatelessWidget {
  const MaterialStyleStylesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;
        final appStyle = state.appSettings.appStyle;

        return MaterialStyleListTileGroup(
          heading: LocaleKeys.styles_title.tr(),
          listTiles: [
            MaterialStyleListTile(
              leading: FaIcon(
                FontAwesomeIcons.android,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: 'Material',
              trailing: appStyle == AppStyle.material
                  ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => context.read<SettingsBloc>().add(const SettingsUpdateAppStyle(AppStyle.material)),
            ),
            MaterialStyleListTile(
              leading: FaIcon(
                FontAwesomeIcons.apple,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: 'Cupertino',
              trailing: appStyle == AppStyle.cupertino
                  ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => context.read<SettingsBloc>().add(const SettingsUpdateAppStyle(AppStyle.cupertino)),
            ),
          ],
        );
      },
    );
  }
}
