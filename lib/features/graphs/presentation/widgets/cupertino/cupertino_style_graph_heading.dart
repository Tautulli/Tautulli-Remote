import 'package:flutter/cupertino.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_heading.dart';

class CupertinoStyleGraphHeading extends StatelessWidget {
  final String text;

  const CupertinoStyleGraphHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CupertinoStyleHeading(
        text: text,
        color: ThemeHelper.cupertinoStandardTextColor(),
      ),
    );
  }
}
