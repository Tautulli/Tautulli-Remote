import 'package:flutter/material.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({Key key}) : super(key: key);

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs'),
        leading: const AppDrawerIcon(),
      ),
      drawer: const AppDrawer(),
      body: DoubleTapExit(
        child: Container(),
      ),
    );
  }
}
