import 'package:flutter/material.dart';

class GesturePill extends StatelessWidget {
  const GesturePill({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 4,
        width: 40,
        color: Colors.white.withOpacity(0.3),
      ),
    );
  }
}
