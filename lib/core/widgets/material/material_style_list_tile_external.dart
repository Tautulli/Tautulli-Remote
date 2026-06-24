import 'package:flutter/material.dart';

class MaterialStyleListTileExternal extends StatelessWidget {
  const MaterialStyleListTileExternal({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.open_in_new,
      size: 20,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
