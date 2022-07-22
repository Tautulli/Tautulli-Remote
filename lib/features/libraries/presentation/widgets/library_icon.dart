import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    if (library.iconUri != null) {
      return CachedNetworkImage(
        imageUrl: library.iconUri.toString(),
      );
    } else {
      return WebsafeSvg.asset(
        AssetHelper.mapSectionTypeToPath(library.sectionType),
        color: Theme.of(context).colorScheme.tertiary,
        height: 50,
      );
    }
  }
}
