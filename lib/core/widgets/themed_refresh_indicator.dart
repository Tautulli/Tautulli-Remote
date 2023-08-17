import 'package:flutter/material.dart';

class ThemedRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ThemedRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.onSurface,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
