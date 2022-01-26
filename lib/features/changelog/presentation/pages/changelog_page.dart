import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/page_body.dart';
import '../../data/datasources/changelog_data_source.dart';
import '../widgets/changelog_item.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key? key}) : super(key: key);

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return const ChangelogView();
  }
}

class ChangelogView extends StatelessWidget {
  const ChangelogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changelog'),
        actions: [
          TextButton.icon(
            onPressed: () {
              //TODO: Donate link
            },
            icon: const FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
              size: 18,
            ),
            label: const Text('Donate'),
          ),
        ],
      ),
      body: PageBody(
        child: ListView.builder(
          itemCount: changelog['data'].length,
          itemBuilder: (context, index) {
            return ChangelogItem(
              changelog['data'][index],
              bottomPadding: index < changelog['data'].length - 1,
            );
          },
        ),
      ),
    );
  }
}
