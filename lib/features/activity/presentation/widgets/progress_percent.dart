import 'package:flutter/material.dart';

class ProgressPercent extends StatelessWidget {
  final int progressPercent;

  const ProgressPercent({
    super.key,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$progressPercent%',
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }
}
