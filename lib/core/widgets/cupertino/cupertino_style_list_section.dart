import 'package:flutter/cupertino.dart';

class CupertinoStyleListSection extends StatelessWidget {
  final String? headerText;
  final List<Widget>? children;
  final BoxDecoration? decoration;
  final bool hasLeading;
  final EdgeInsetsGeometry? margin;

  const CupertinoStyleListSection({
    super.key,
    this.headerText,
    this.children,
    this.decoration,
    this.hasLeading = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      margin: margin,
      decoration: decoration,
      hasLeading: hasLeading,
      header: headerText != null
          ? Text(
              headerText!,
              style: TextStyle(
                color: CupertinoTheme.of(context).primaryColor,
              ),
            )
          : null,
      backgroundColor: CupertinoColors.transparent,
      children: children,
    );
  }
}
