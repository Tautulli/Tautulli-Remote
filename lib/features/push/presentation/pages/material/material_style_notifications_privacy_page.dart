import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/material_style_notifications_privacy_list_tile.dart';
import '../../widgets/material/material_style_notifications_privacy_text.dart';

class MaterialStyleNotificationsPrivacyPage extends StatelessWidget {
  final bool showToggle;

  const MaterialStyleNotificationsPrivacyPage({
    super.key,
    this.showToggle = true,
  });

  static const routeName = '/notifications_privacy';

  @override
  Widget build(BuildContext context) {
    return MaterialStyleNotificationsPrivacyView(showToggle: showToggle);
  }
}

class MaterialStyleNotificationsPrivacyView extends StatelessWidget {
  final bool showToggle;

  const MaterialStyleNotificationsPrivacyView({
    super.key,
    required this.showToggle,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.notifications_data_privacy_title).tr(),
      ),
      body: MaterialStylePageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MaterialStyleNotificationsPrivacyText(),
              if (showToggle) const Gap(8),
              if (showToggle)
                const MaterialStyleListTileGroup(
                  listTiles: [
                    MaterialStyleNotificationsPrivacyListTile(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
