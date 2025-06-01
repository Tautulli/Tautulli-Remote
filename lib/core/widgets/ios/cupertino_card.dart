import 'package:flutter/cupertino.dart';

class CupertinoCard extends StatelessWidget {
  final Widget child;

  const CupertinoCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          color: CupertinoColors.systemBackground.darkElevatedColor,
          child: child,
        ),
      ),
    );
  }
}
