import 'package:flutter/material.dart';

class BulletItem extends StatelessWidget {
  final String text;

  const BulletItem(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('•'),
            const SizedBox(width: 4),
            Expanded(
              child: Text(text),
            ),
          ],
        ));
  }
}
