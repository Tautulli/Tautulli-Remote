import 'package:flutter/material.dart';

import '../../data/datasource/changelog_data_source.dart';
import '../widgets/changelog_item.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key key}) : super(key: key);

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Changelog'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: changelog['data'].map<Widget>((release) {
              return ChangelogItem(
                release: release,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
