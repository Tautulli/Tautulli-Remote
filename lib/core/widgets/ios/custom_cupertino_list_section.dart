import 'package:flutter/cupertino.dart';

class CustomCupertinoListSection extends StatelessWidget {
  final String? headerText;
  final List<Widget>? children;

  const CustomCupertinoListSection({
    super.key,
    this.headerText,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: headerText != null ? Text(headerText!) : null,
      backgroundColor: CupertinoColors.transparent,
      children: children,
    );
  }
}
