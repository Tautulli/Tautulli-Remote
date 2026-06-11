import 'package:flutter/material.dart';

class MaterialStyleGesturePill extends StatelessWidget {
  const MaterialStyleGesturePill({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 4,
        width: 40,
        color: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }
}
