import 'package:flutter/material.dart';

class BulletItem extends StatelessWidget {
  final String text;
  final double fontSize;

  const BulletItem(
    this.text, {
    Key key,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•',
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ));
  }
}
