import 'package:flutter/cupertino.dart';

class PageScaffoldCupertino extends StatelessWidget {
  final Widget? leading;
  final Widget middle;
  final Widget child;

  const PageScaffoldCupertino({
    super.key,
    this.leading,
    required this.middle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: leading,
        middle: middle,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
