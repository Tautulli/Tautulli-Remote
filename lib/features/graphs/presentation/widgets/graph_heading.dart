import 'package:flutter/material.dart';

import '../../../../core/widgets/heading.dart';

class GraphHeading extends StatelessWidget {
  final String text;

  const GraphHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Heading(
        text: text,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
