import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BulletList extends StatelessWidget {
  final List<String> listItems;

  const BulletList({
    super.key,
    required this.listItems,
  });

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
                const Gap(4),
                Expanded(child: Text(item)),
              ],
            ),
          )
          .toList(),
    );
  }
}
