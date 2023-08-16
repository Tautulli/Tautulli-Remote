import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/asset_helper.dart';
import '../../data/models/library_table_model.dart';

class LibraryIcon extends StatelessWidget {
  final LibraryTableModel library;

  const LibraryIcon({
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
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
                height: 50,
              );
            }
          },
        ),
        if (library.isActive != true)
          Positioned(
            bottom: -1,
            right: 0,
            child: Stack(
              children: [
                Positioned(
                  bottom: 3,
                  right: 5,
                  child: FaIcon(
                    FontAwesomeIcons.solidCircle,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 14,
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  size: 24,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
