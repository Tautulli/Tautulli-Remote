import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  final Widget child;
  final bool loading;

  const PageBody({
    super.key,
    required this.child,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          child,
          if (loading)
            LinearProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Colors.transparent,
            ),
        ],
      ),
    );
  }
}
