import 'package:flutter/cupertino.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';

class CupertinoStylePlatformIcon extends StatelessWidget {
  final String? platformName;

  const CupertinoStylePlatformIcon({
    super.key,
    required this.platformName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        width: 40,
        color: TautulliColorPalette.mapPlatformToColor(platformName),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: WebsafeSvg.asset(
            AssetHelper.mapPlatformToPath(platformName),
            colorFilter: ColorFilter.mode(
              ThemeHelper.cupertinoCardIconColor(),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
