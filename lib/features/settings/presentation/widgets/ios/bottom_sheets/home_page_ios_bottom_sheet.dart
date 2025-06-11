import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class HomePageIosBottomSheet extends StatelessWidget {
  final String initialValue;

  const HomePageIosBottomSheet({
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

    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.home_page_title).tr(),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('activity');
            },
            title: const Text(LocaleKeys.activity_title).tr(),
            trailing: initialValue == 'activity' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('history');
            },
            title: const Text(LocaleKeys.history_title).tr(),
            trailing: initialValue == 'history' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('recent');
            },
            title: const Text(LocaleKeys.recently_added_title).tr(),
            trailing: initialValue == 'recent' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('libraries');
            },
            title: const Text(LocaleKeys.libraries_title).tr(),
            trailing: initialValue == 'libraries' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('users');
            },
            title: const Text(LocaleKeys.users_title).tr(),
            trailing: initialValue == 'users' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('statistics');
            },
            title: const Text(LocaleKeys.statistics_title).tr(),
            trailing: initialValue == 'statistics' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              homePageChanged('graphs');
            },
            title: const Text(LocaleKeys.graphs_title).tr(),
            trailing: initialValue == 'graphs' ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
