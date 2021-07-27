import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import 'app_drawer.dart';
import 'app_drawer_icon.dart';
import 'double_tap_exit.dart';

class InnerDrawerScaffold extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget> actions;

  const InnerDrawerScaffold({
    Key key,
    @required this.title,
    @required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<InnerDrawerState> _innerDrawerKey =
        GlobalKey<InnerDrawerState>();

    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      swipeChild: true,
      offset: const IDOffset.horizontal(0.5),
      leftChild: const AppDrawer(),
      scaffold: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: AppDrawerIcon(innerDrawerKey: _innerDrawerKey),
          title: title,
          actions: actions ?? [],
        ),
        body: DoubleTapExit(
          child: body,
        ),
      ),
    );
  }
}
