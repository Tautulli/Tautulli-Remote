import 'package:flutter/cupertino.dart';

class PageScaffoldCupertino extends StatelessWidget {
  final Widget title;
  final Widget child;

  const PageScaffoldCupertino({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: title,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
