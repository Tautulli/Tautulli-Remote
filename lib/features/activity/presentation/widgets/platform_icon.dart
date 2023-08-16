import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/asset_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';

class PlatformIcon extends StatelessWidget {
  final String? platformName;

  const PlatformIcon({
    super.key,
    required this.platformName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
