import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/material_style_onesignal_data_privacy_list_tile.dart';
import '../../widgets/material/material_style_onesignal_data_privacy_text.dart';

class MaterialStyleOneSignalDataPrivacyPage extends StatelessWidget {
  final bool showToggle;

  const MaterialStyleOneSignalDataPrivacyPage({
    super.key,
    this.showToggle = true,
  });

  static const routeName = '/onesignal_privacy';

  @override
  Widget build(BuildContext context) {
    return MaterialStyleOneSignalDataPrivacyView(showToggle: showToggle);
  }
}

class MaterialStyleOneSignalDataPrivacyView extends StatelessWidget {
  final bool showToggle;

  const MaterialStyleOneSignalDataPrivacyView({
    super.key,
    required this.showToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.onesignal_data_privacy_title).tr(),
      ),
      body: MaterialStylePageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MaterialStyleOnesignalDataPrivacyText(),
              if (showToggle) const Gap(8),
              if (showToggle)
                const MaterialStyleListTileGroup(
                  listTiles: [
                    MaterialStyleOnesignalDataPrivacyListTile(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
