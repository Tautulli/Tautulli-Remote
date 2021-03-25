import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class UserStatisticHeading extends StatelessWidget {
  final String heading;

  const UserStatisticHeading({
    Key key,
    @required this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              top: 8,
              bottom: 6,
            ),
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            indent: 9,
            endIndent: MediaQuery.of(context).size.width - 100,
            height: 7,
            thickness: 1,
            color: PlexColorPalette.gamboge,
          ),
          // const SizedBox(height: 7),
        ],
      ),
    );
  }
}
