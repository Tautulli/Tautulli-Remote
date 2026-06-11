import 'package:flutter/material.dart';

class MaterialStyleCard extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const MaterialStyleCard({
    super.key,
    this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: ElevationOverlay.applySurfaceTint(
          color ?? Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1,
        ),
        child: child,
      ),
    );
  }
}
