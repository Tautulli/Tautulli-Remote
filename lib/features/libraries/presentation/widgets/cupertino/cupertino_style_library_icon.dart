import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../data/models/library_table_model.dart';

class CupertinoStyleLibraryIcon extends StatelessWidget {
  final LibraryTableModel library;

  const CupertinoStyleLibraryIcon({
    super.key,
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(
          builder: (context) {
            if (library.iconUri != null) {
              return CachedNetworkImage(
                imageUrl: library.iconUri.toString(),
              );
            } else {
              return WebsafeSvg.asset(
                AssetHelper.mapSectionTypeToPath(library.sectionType),

                height: 50,
              );
            }
          },
        ),
        if (library.isActive != true)
          Positioned(
            bottom: -4,
            right: 0,
            child: Stack(
              children: [
                Positioned(
                  bottom: 3,
                  right: 5,
                  child: Icon(
                    CupertinoIcons.circle_fill,
                    color: ThemeHelper.cupertinoCardIconColor(),
                    size: 16,
                  ),
                ),
                Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  color: CupertinoTheme.of(context).primaryColor,
                  size: 26,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
