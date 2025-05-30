import 'package:flutter/cupertino.dart';

class CustomCupertinoListSection extends StatelessWidget {
  final String headerText;
  final List<Widget>? children;

  const CustomCupertinoListSection({
    super.key,
    required this.headerText,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Text(headerText),
      backgroundColor: CupertinoColors.transparent,
      children: children,
    );
  }
}
