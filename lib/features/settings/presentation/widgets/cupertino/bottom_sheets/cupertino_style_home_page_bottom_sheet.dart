import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleHomePageBottomSheet extends StatelessWidget {
  final String initialValue;

  const CupertinoStyleHomePageBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void homePageChanged(String value) {
      context.read<SettingsBloc>().add(
        SettingsUpdateHomePage(value),
      );
      Navigator.of(context).pop();
    }

    return CupertinoStyleModalPopupScaffold(
      middleText: LocaleKeys.home_page_title.tr(),
      leading: const CupertinoStyleBottomSheetCancelButton(),
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('activity');
            },
            titleText: LocaleKeys.activity_title.tr(),
            trailing: initialValue == 'activity' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('history');
            },
            titleText: LocaleKeys.history_title.tr(),
            trailing: initialValue == 'history' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('recent');
            },
            titleText: LocaleKeys.recently_added_title.tr(),
            trailing: initialValue == 'recent' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('libraries');
            },
            titleText: LocaleKeys.libraries_title.tr(),
            trailing: initialValue == 'libraries' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('users');
            },
            titleText: LocaleKeys.users_title.tr(),
            trailing: initialValue == 'users' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('statistics');
            },
            titleText: LocaleKeys.statistics_title.tr(),
            trailing: initialValue == 'statistics' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('graphs');
            },
            titleText: LocaleKeys.graphs_title.tr(),
            trailing: initialValue == 'graphs' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
