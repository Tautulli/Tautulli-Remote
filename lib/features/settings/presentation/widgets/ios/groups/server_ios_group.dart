import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';

class ServersIosGroup extends StatelessWidget {
  const ServersIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.servers_title.tr(),
      children: [],
    );
  }
}
