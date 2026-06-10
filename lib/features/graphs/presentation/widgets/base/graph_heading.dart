import 'package:flutter/widgets.dart';

import '../../../../../core/widgets/heading.dart';

class GraphHeading extends StatelessWidget {
  final String text;
  final Color color;

  const GraphHeading({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Heading(
        text: text,
        color: color,
      ),
    );
  }
}
