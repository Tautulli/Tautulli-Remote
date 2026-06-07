import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/app_style.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleStylesGroup extends StatelessWidget {
  const CupertinoStyleStylesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return CustomCupertinoListSection(
          //TODO:  Create translation key
          headerText: 'Styles',
          children: [
            CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.android,
                color: ThemeHelper.cupertinoListTileIconColor(),
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
            CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.apple,
                color: ThemeHelper.cupertinoListTileIconColor(),
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
