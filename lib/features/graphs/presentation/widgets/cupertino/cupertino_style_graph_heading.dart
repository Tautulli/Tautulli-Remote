import 'package:flutter/cupertino.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/heading_ios.dart';

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
      child: HeadingIos(
        text: text,
        color: ThemeHelper.cupertinoStandardTextColor(),
      ),
    );
  }
}
