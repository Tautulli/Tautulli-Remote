import 'package:flutter/material.dart';

import 'heading.dart';

class ListTileGroup extends StatelessWidget {
  final String? heading;
  final List<Widget> listTiles;

  const ListTileGroup({
    Key? key,
    this.heading,
    required this.listTiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Heading(
              text: heading!,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: heading != null ? 8 : 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
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
