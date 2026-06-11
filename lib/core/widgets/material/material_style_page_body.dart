import 'package:flutter/material.dart';

class MaterialStylePageBody extends StatelessWidget {
  final Widget child;
  final bool loading;

  const MaterialStylePageBody({
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
