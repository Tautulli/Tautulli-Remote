import 'package:flutter/material.dart';

class MaterialStyleListTileChevron extends StatelessWidget {
  const MaterialStyleListTileChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
