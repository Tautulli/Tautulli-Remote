import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class GraphHeading extends StatelessWidget {
  final String graphHeading;

  const GraphHeading({
    Key key,
    @required this.graphHeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            top: 6,
            bottom: 6,
          ),
          child: Text(
            graphHeading,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Divider(
          indent: 8,
          endIndent: MediaQuery.of(context).size.width - 100,
          height: 7,
          thickness: 1,
          color: PlexColorPalette.gamboge,
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}
