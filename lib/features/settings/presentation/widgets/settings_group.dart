import 'package:flutter/material.dart';

import 'settings_heading.dart';

class SettingsGroup extends StatelessWidget {
  final String? heading;
  final List<Widget> settingsListTiles;

  const SettingsGroup({
    Key? key,
    this.heading,
    required this.settingsListTiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: SettingsHeading(
                    text: heading!,
                  ),
                )
              : const SizedBox(height: 0, width: 0),
          Padding(
            padding: EdgeInsets.only(top: heading != null ? 8 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: settingsListTiles,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
