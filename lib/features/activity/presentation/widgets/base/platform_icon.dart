import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/types/app_style.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';

class PlatformIcon extends StatelessWidget {
  final String? platformName;
  final Color iconColor;

  const PlatformIcon({
    super.key,
    required this.platformName,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        if (state.appSettings.appStyle == AppStyle.cupertino) {
          return ClipRSuperellipse(
            borderRadius: BorderRadius.circular(10),
            child: _platformIconChild(context),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _platformIconChild(context),
          );
        }
      },
    );
  }

  Widget _platformIconChild(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      color: TautulliColorPalette.mapPlatformToColor(platformName),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: WebsafeSvg.asset(
          AssetHelper.mapPlatformToPath(platformName),
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
