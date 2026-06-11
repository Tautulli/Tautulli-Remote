import 'package:flutter/material.dart';

class MaterialStyleRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const MaterialStyleRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onSurface,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
