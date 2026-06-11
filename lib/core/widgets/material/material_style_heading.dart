import 'package:flutter/material.dart';

class MaterialStyleHeading extends StatelessWidget {
  final String text;
  final Color? color;

  const MaterialStyleHeading({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
