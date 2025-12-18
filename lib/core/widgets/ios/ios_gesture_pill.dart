import 'package:flutter/cupertino.dart';

class IosGesturePill extends StatelessWidget {
  const IosGesturePill({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 4,
        width: 40,
        color: CupertinoColors.white.withValues(alpha: 0.3),
      ),
    );
  }
}
