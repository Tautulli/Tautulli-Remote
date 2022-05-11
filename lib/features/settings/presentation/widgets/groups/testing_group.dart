import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../pages/data_dump.dart';
import '../../pages/how_to_test_page.dart';

class TestingGroup extends StatelessWidget {
  const TestingGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: 'Testing',
      listTiles: [
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.handshakeSimple),
          title: 'How To Test',
          subtitle: 'Help make v3 the best version of itself',
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const HowToTestPage(),
              ),
            );
          },
        ),
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.faucet),
          title: LocaleKeys.data_dump_title.tr(),
          subtitle: LocaleKeys.data_dump_subtitle.tr(),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const DataDumpPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
