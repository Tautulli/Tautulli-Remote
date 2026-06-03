import 'package:flutter/cupertino.dart';

class CupertinoModalPopupScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final Widget child;

  const CupertinoModalPopupScaffold({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: NavigationToolbar(
                leading: leading,
                middle: middle,
                trailing: trailing,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
