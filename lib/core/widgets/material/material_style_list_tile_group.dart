import 'package:flutter/material.dart';

import 'material_style_heading.dart';

class MaterialStyleListTileGroup extends StatelessWidget {
  final String? heading;
  final List<Widget> listTiles;

  const MaterialStyleListTileGroup({
    super.key,
    this.heading,
    required this.listTiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: MaterialStyleHeading(
              text: heading!,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: heading != null ? 8 : 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: listTiles,
            ),
          ),
        ),
      ],
    );
  }
}
