import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String text;
  final Color? color;

  const Heading({
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
