import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../core/types/theme_type.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ThemesIosGroup extends StatelessWidget {
  const ThemesIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      state as SettingsSuccess;

      return CustomCupertinoListSection(
        headerText: LocaleKeys.themes_title.tr(),
        children: [
          CupertinoListTile.notched(
            leading: WebsafeSvg.asset(
              'assets/logos/logo_flat.svg',
              colorFilter: ColorFilter.mode(
                CupertinoTheme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
            trailing: state.appSettings.theme == ThemeType.tautulli ? const Icon(CupertinoIcons.check_mark) : null,
            title: const Text('Tautulli'),
            subtitle: const Text(LocaleKeys.tautulli_theme_subtitle).tr(),
            onTap: () {
              context.read<SettingsBloc>().add(
                    const SettingsUpdateTheme(ThemeType.tautulli),
                  );
            },
          ),
          CupertinoListTile.notched(
            leading: const FaIcon(FontAwesomeIcons.swatchbook),
            trailing: state.appSettings.theme == ThemeType.dynamic ? const Icon(CupertinoIcons.check_mark) : null,
            title: const Text(LocaleKeys.dynamic_title).tr(),
            subtitle: const Text(LocaleKeys.dynamic_theme_subtitle).tr(),
            onTap: () {
              context.read<SettingsBloc>().add(
                    const SettingsUpdateTheme(ThemeType.dynamic),
                  );
            },
          ),
        ],
      );
    });
  }
}
