import 'package:flutter/cupertino.dart';

class CustomCupertinoListSection extends StatelessWidget {
  final String? headerText;
  final List<Widget>? children;
  final BoxDecoration? decoration;
  final bool hasLeading;

  const CustomCupertinoListSection({
    super.key,
    this.headerText,
    this.children,
    this.decoration,
    this.hasLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
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
