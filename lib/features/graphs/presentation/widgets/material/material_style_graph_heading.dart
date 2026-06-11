import 'package:flutter/material.dart';

import '../../../../../core/widgets/material/material_style_heading.dart';

class MaterialStyleGraphHeading extends StatelessWidget {
  final String text;
  final Color color;

  const MaterialStyleGraphHeading({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialStyleHeading(
        text: text,
        color: color,
      ),
    );
  }
}
