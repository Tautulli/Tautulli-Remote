import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/onesignal_data_privacy_list_tile.dart';
import '../widgets/onesignal_data_privacy_text.dart';

class OneSignalDataPrivacyPage extends StatelessWidget {
  final bool showToggle;

  const OneSignalDataPrivacyPage({
    super.key,
    this.showToggle = true,
  });

  static const routeName = '/onesignal_privacy';

  @override
  Widget build(BuildContext context) {
    return OneSignalDataPrivacyView(showToggle: showToggle);
  }
}

class OneSignalDataPrivacyView extends StatelessWidget {
  final bool showToggle;

  const OneSignalDataPrivacyView({
    super.key,
    required this.showToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.onesignal_data_privacy_title).tr(),
      ),
      body: PageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OnesignalDataPrivacyText(),
              if (showToggle) const Gap(8),
              if (showToggle)
                const ListTileGroup(
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
