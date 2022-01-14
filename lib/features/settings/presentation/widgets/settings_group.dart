import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  final String heading;
  final List<Widget> settingsListTiles;

  const SettingsGroup({
    Key? key,
    required this.heading,
    required this.settingsListTiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 8,
            right: 16,
          ),
          child: Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: settingsListTiles,
            ),
          ),
        ),
      ],
    );
  }
}
