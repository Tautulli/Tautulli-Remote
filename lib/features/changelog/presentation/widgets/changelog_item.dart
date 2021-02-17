import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import 'change_type_tag.dart';

class ChangelogItem extends StatelessWidget {
  final Map release;

  const ChangelogItem({
    @required this.release,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                release['version'],
                style: TextStyle(
                  color: TautulliColorPalette.not_white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                release['date'],
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Divider(
              height: 0,
              color: PlexColorPalette.gamboge,
            ),
          ),
          //* Changes
          Column(
            children: release['changes'].map<Widget>((change) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          ChangeTypeTag(change['type']),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(change['detail']),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
