import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> listItems;

  const BulletList({
    Key? key,
    required this.listItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: listItems
          .map(
            (item) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•'),
                const SizedBox(width: 4),
                Expanded(child: Text(item)),
              ],
            ),
          )
          .toList(),
    );
  }
}
