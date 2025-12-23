import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/theme_helper.dart';
import '../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../donate/presentation/pages/ios/donate_ios_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/pages/ios/settings_ios_page.dart';

class MoreIosPage extends StatelessWidget {
  const MoreIosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MoreIosView();
  }
}

class MoreIosView extends StatelessWidget {
  const MoreIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return PageScaffoldCupertino(
          showBackButton: false,
          middle: const Text(LocaleKeys.more_title).tr(),
          child: Column(
            children: [
              CustomCupertinoListSection(
                children: [
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.person_2_fill,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    title: const Text(LocaleKeys.users_title).tr(),
                    // onTap: () => showCupertinoSheet(
                    //   context: context,
                    //   builder: (context) => ServerTimeoutIosBottomSheet(
                    //     initialValue: serverTimeout,
                    //   ),
                    // ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.list_number,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    title: const Text(LocaleKeys.statistics_title).tr(),
                    // onTap: () => showCupertinoSheet(
                    //   context: context,
                    //   builder: (context) => ServerTimeoutIosBottomSheet(
                    //     initialValue: serverTimeout,
                    //   ),
                    // ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.chart_bar_alt_fill,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    title: const Text(LocaleKeys.graphs_title).tr(),
                    // onTap: () => showCupertinoSheet(
                    //   context: context,
                    //   builder: (context) => ServerTimeoutIosBottomSheet(
                    //     initialValue: serverTimeout,
                    //   ),
                    // ),
                  ),
                ],
              ),
              CustomCupertinoListSection(
                children: [
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.bell_fill,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    title: const Text(LocaleKeys.announcements_title).tr(),
                    // subtitle: Text(_serverTimeoutDisplay(serverTimeout)),
                    // onTap: () => showCupertinoSheet(
                    //   context: context,
                    //   builder: (context) => ServerTimeoutIosBottomSheet(
                    //     initialValue: serverTimeout,
                    //   ),
                    // ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: const Icon(
                      CupertinoIcons.heart_fill,
                      color: CupertinoColors.systemRed,
                    ),
                    trailing: const CupertinoListTileChevron(),
                    title: const Text(LocaleKeys.donate_title).tr(),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => DonateIosPage(
                          showBackButton: true,
                          previousPageTitle: LocaleKeys.more_title.tr(),
                        ),
                      ),
                    ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.gear_alt_fill,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    title: const Text(LocaleKeys.settings_title).tr(),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => SettingsIosPage(
                          showBackButton: true,
                          previousPageTitle: LocaleKeys.more_title.tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
