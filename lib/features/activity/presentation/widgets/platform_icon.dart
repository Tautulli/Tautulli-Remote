import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';

class PlatformIcon extends StatelessWidget {
  final platform;

  PlatformIcon(this.platform);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        child: Container(
          color: TautulliColorPalette().mapPlatformToColor(platform),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: WebsafeSvg.asset(
              AssetMapperHelper().mapPlatformToPath(platform),
            ),
          ),
        ),
      ),
    );
  }
}
