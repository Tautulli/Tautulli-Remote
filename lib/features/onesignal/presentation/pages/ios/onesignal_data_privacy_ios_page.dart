import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/onesignal_data_privacy_cupertino_list_tile.dart';
import '../../widgets/ios/onesignal_data_privacy_ios_text.dart';

class OneSignalDataPrivacyIosPage extends StatelessWidget {
  final String? previousPageTitle;
  final bool showToggle;

  const OneSignalDataPrivacyIosPage({
    super.key,
    this.previousPageTitle,
    this.showToggle = true,
  });

  static const routeName = '/onesignal_privacy';

  @override
  Widget build(BuildContext context) {
    return OneSignalDataPrivacyIosView(
      previousPageTitle: previousPageTitle,
      showToggle: showToggle,
    );
  }
}

class OneSignalDataPrivacyIosView extends StatelessWidget {
  final String? previousPageTitle;
  final bool showToggle;

  const OneSignalDataPrivacyIosView({
    super.key,
    this.previousPageTitle,
    required this.showToggle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.onesignal_data_privacy_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: previousPageTitle,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const OneSignalDataPrivacyIosText(),
            if (showToggle)
              const CustomCupertinoListSection(
                children: [
                  OneSignalDataPrivacyCupertinoListTile(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
