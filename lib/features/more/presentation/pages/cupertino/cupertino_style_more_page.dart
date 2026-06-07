import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/global_keys/global_keys.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../announcements/presentation/bloc/announcements_bloc.dart';
import '../../../../announcements/presentation/pages/ios/announcements_ios_page.dart';
import '../../../../donate/presentation/pages/ios/donate_ios_page.dart';
import '../../../../graphs/presentation/pages/ios/graphs_ios_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../settings/presentation/pages/cupertino/cupertino_style_settings_page.dart';
import '../../../../statistics/presentation/pages/cupertino/cupertino_style_statistics_page.dart';
import '../../../../users/presentation/pages/cupertino/cupertino_style_users_page.dart';

class CupertinoStyleMorePage extends StatelessWidget {
  const CupertinoStyleMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoStyleMoreView();
  }
}

class CupertinoStyleMoreView extends StatefulWidget {
  const CupertinoStyleMoreView({super.key});

  @override
  State<CupertinoStyleMoreView> createState() => _CupertinoStyleMoreViewState();
}

class _CupertinoStyleMoreViewState extends State<CupertinoStyleMoreView> {
  String? _currentRoute;

  @override
  void initState() {
    super.initState();

    moreNavigationPage.addListener(_handleMoreNavigation);

    if (moreNavigationPage.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMoreNavigation();
      });
    }
  }

  @override
  void dispose() {
    moreNavigationPage.removeListener(_handleMoreNavigation);
    super.dispose();
  }

  void _handleMoreNavigation() {
    if (moreNavigationPage.value == null) return;
    if (!mounted) return;

    final page = moreNavigationPage.value;
    moreNavigationPage.value = null;

    switch (page) {
      case 'settings':
        if (_currentRoute == 'settings') return;
        _currentRoute = 'settings';
        Navigator.of(context)
            .push(
              CupertinoPageRoute(
                builder: (context) => CupertinoStyleSettingsPage(
                  showBackButton: true,
                  previousPageTitle: LocaleKeys.more_title.tr(),
                ),
              ),
            )
            .then((_) => _currentRoute = null);
    }
  }

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
                    titleText: LocaleKeys.users_title.tr(),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleUsersPage(
                          showBackButton: true,
                          previousPageTitle: LocaleKeys.more_title.tr(),
                        ),
                      ),
                    ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.list_number,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    titleText: LocaleKeys.statistics_title.tr(),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleStatisticsPage(
                          showBackButton: true,
                          previousPageTitle: LocaleKeys.more_title.tr(),
                        ),
                      ),
                    ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.chart_bar_alt_fill,
                      color: ThemeHelper.cupertinoListTileIconColor(),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    titleText: LocaleKeys.graphs_title.tr(),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => GraphsIosPage(
                          showBackButton: true,
                          previousPageTitle: LocaleKeys.more_title.tr(),
                        ),
                      ),
                    ),
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
                    trailing: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            if (state is AnnouncementsSuccess && state.unread)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  CupertinoIcons.circle_fill,
                                  size: 12,
                                  color: CupertinoTheme.of(context).primaryColor,
                                ),
                              ),
                            const CupertinoListTileChevron(),
                          ],
                        );
                      },
                    ),
                    titleText: LocaleKeys.announcements_title.tr(),
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => AnnouncementsIosPage(
                          showBackButton: true,
                          previousPageTitle: LocaleKeys.more_title.tr(),
                        ),
                      ),
                    ),
                  ),
                  CustomNotchedCupertinoListTile(
                    leading: const Icon(
                      CupertinoIcons.heart_fill,
                      color: CupertinoColors.systemRed,
                    ),
                    trailing: const CupertinoListTileChevron(),
                    titleText: LocaleKeys.donate_title.tr(),
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
                    titleText: LocaleKeys.settings_title.tr(),
                    onTap: () {
                      _currentRoute = 'settings';

                      return Navigator.of(context)
                          .push(
                            CupertinoPageRoute(
                              builder: (context) => CupertinoStyleSettingsPage(
                                showBackButton: true,
                                previousPageTitle: LocaleKeys.more_title.tr(),
                              ),
                            ),
                          )
                          .then((_) => _currentRoute = null);
                    },
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
