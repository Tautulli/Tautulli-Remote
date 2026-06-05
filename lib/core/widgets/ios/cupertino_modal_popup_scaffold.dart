import 'package:flutter/cupertino.dart';

class CupertinoModalPopupScaffold extends StatelessWidget {
  final Widget? leading;
  final String? middleText;
  final Widget? trailing;
  final Widget child;

  const CupertinoModalPopupScaffold({
    super.key,
    this.leading,
    this.middleText,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;

    final navigationToolbar = SizedBox(
      height: 42,
      child: NavigationToolbar(
        leading: leading,
        middle: middleText != null
            ? DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                textAlign: TextAlign.center,
                child: Text(middleText!),
              )
            : null,
        trailing: trailing,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            navigationToolbar,
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
