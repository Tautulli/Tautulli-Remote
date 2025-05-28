import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';

class ActivityIosPage extends StatelessWidget {
  const ActivityIosPage({super.key});

  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      title: Text('Activity'),
      child: Center(
        child: Text('activity'),
      ),
    );
  }
}
