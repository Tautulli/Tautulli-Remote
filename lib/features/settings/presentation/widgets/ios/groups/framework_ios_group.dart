import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/framework.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../bloc/settings_bloc.dart';

class FrameworkIosGroup extends StatelessWidget {
  const FrameworkIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return CustomCupertinoListSection(
          //TODO:  Create translation key
          headerText: 'Framework',
          children: [
            CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.android,
                color: ThemeHelper.cupertinoListTileIconColor(),
                size: 21.3,
              ),
              //TODO:  Create translation key
              titleText: 'Android',
              trailing: state.appSettings.framework == Framework.android
                  ? const Icon(CupertinoIcons.checkmark_alt)
                  : null,
              onTap: () {
                context.read<SettingsBloc>().add(
                  const SettingsUpdateFramework(Framework.android),
                );
              },
            ),
            CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.apple,
                color: ThemeHelper.cupertinoListTileIconColor(),
                size: 23,
              ),
              //TODO:  Create translation key
              titleText: 'iOS',
              trailing: state.appSettings.framework == Framework.ios ? const Icon(CupertinoIcons.checkmark_alt) : null,
              onTap: () {
                context.read<SettingsBloc>().add(
                  const SettingsUpdateFramework(Framework.ios),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
