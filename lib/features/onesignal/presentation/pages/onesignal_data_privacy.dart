import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../widgets/onesignal_data_privacy_list_tile.dart';
import '../widgets/onesignal_data_privacy_text.dart';

class OneSignalDataPrivacyPage extends StatelessWidget {
  const OneSignalDataPrivacyPage({Key? key}) : super(key: key);

  static const routeName = '/onesignal_privacy';

  @override
  Widget build(BuildContext context) {
    return const OneSignalDataPrivacyView();
  }
}

class OneSignalDataPrivacyView extends StatelessWidget {
  const OneSignalDataPrivacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OneSignal Data Privacy'),
      ),
      body: PageBody(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              OnesignalDataPrivacyText(),
              Gap(8),
              ListTileGroup(
                listTiles: [
                  OneSignalDataPrivacyListTile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
