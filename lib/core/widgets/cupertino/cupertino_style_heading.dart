import 'package:flutter/cupertino.dart';

class CupertinoStyleHeading extends StatelessWidget {
  final String text;
  final Color? color;

  const CupertinoStyleHeading({
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
        color: color ?? CupertinoTheme.of(context).primaryColor,
      ),
    );
  }
}
