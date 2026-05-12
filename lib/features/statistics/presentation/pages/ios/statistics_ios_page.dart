import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/types/play_metric_type.dart';
import '../../../../../core/types/stat_id_type.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../core/widgets/ios/ios_icon_card.dart';
import '../../../../../core/widgets/ios/ios_poster_card.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../core/widgets/ios/time_range_ios_bottom_sheet.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../libraries/data/models/library_table_model.dart';
import '../../../../libraries/presentation/widgets/ios/library_ios_card.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_table_model.dart';
import '../../../../users/presentation/widgets/ios/user_ios_card.dart';
import '../../../data/models/statistic_data_model.dart';
import '../../../data/models/statistic_model.dart';
import '../../bloc/statistics_bloc.dart';
import '../../widgets/ios/bottom_sheets/statistic_type_ios_bottom_sheet.dart';
import '../../widgets/ios/last_watched_statistic_ios_details.dart';
import '../../widgets/ios/most_concurrent_statistic_ios_details.dart';
import '../../widgets/ios/popular_statistic_ios_details.dart';
import '../../widgets/ios/statistics_ios_heading.dart';
import '../../widgets/ios/top_libraries_statistic_ios_details.dart';
import '../../widgets/ios/top_platforms_statistic_ios_details.dart';
import '../../widgets/ios/top_statistic_ios_details.dart';
import '../../widgets/ios/top_users_statistic_ios_details.dart';

class StatisticsIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const StatisticsIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    this.refreshOnLoad = false,
  });

  static const routeName = '/statistics';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<StatisticsBloc>(),
      child: StatisticsIosView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
        refreshOnLoad: refreshOnLoad,
      ),
    );
  }
}

class StatisticsIosView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const StatisticsIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.refreshOnLoad,
  });

  @override
  State<StatisticsIosView> createState() => _StatisticsIosViewState();
}

class _StatisticsIosViewState extends State<StatisticsIosView> {
  late ServerModel _server;
  late PlayMetricType _statsType;
  late int _timeRange;
  late StatisticsBloc _statisticsBloc;
  late SettingsBloc _settingsBloc;
  final _scrollController = ScrollController();
  late Completer<void> _refreshCompleter;
  bool _filterRefresh = true;

  @override
  void initState() {
    super.initState();

    _statisticsBloc = context.read<StatisticsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;
    _statsType = settingsState.appSettings.statisticsStatType;
    _timeRange = settingsState.appSettings.statisticsTimeRange;

    _refreshCompleter = Completer<void>();

    _statisticsBloc.add(
      StatisticsFetched(
        server: _server,
        timeRange: _timeRange,
        statsType: _statsType,
        settingsBloc: _settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer != current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;

          _filterRefresh = true;

          _statisticsBloc.add(
            StatisticsFetched(
              server: _server,
              timeRange: _timeRange,
              statsType: _statsType,
              freshFetch: true,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: PageScaffoldCupertino(
        showBackButton: widget.showBackButton,
        previousPageTitle: widget.previousPageTitle,
        showServerSelect: true,
        trailing: _navBarActions(),
        middle: const Text(LocaleKeys.statistics_title).tr(),
        child: BlocConsumer<StatisticsBloc, StatisticsState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              _filterRefresh = false;
            }
          },
          builder: (context, state) {
            List<Widget> statsListWidgets = _buildStatListWidgets(state.statList);

            if (state.statList.isEmpty) {
              if (state.status == BlocStatus.failure) {
                return _statusWidget(
                  child: StatusIosPage(
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  ),
                );
              }
              if (state.status == BlocStatus.success) {
                return _statusWidget(
                  child: StatusIosPage(
                    message: LocaleKeys.recently_added_empty_message.tr(),
                  ),
                );
              }
            }

            if (_filterRefresh && [BlocStatus.initial, BlocStatus.inProgress].contains(state.status)) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return CupertinoScrollbar(
              controller: _scrollController,
              child: CupertinoRefreshPage(
                scrollController: _scrollController,
                onRefresh: () {
                  _statisticsBloc.add(
                    StatisticsFetched(
                      server: _server,
                      timeRange: _timeRange,
                      statsType: _statsType,
                      freshFetch: true,
                      settingsBloc: _settingsBloc,
                    ),
                  );

                  return _refreshCompleter.future;
                },
                sliver: SliverPadding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(statsListWidgets),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusWidget({required Widget child}) {
    return CupertinoRefreshPage(
      onRefresh: () {
        _statisticsBloc.add(
          StatisticsFetched(
            server: _server,
            timeRange: _timeRange,
            statsType: _statsType,
            freshFetch: true,
            settingsBloc: _settingsBloc,
          ),
        );

        return _refreshCompleter.future;
      },
      sliver: SliverFillRemaining(child: child),
    );
  }

  List<Widget> _buildStatListWidgets(List<StatisticModel> statList) {
    List<Widget> widgetList = [];

    for (var i = 0; i < statList.length; i++) {
      final StatisticModel stat = statList[i];
      final int displayCount = min(5, stat.stats.length);

      if (stat.stats.isNotEmpty) {
        widgetList.add(
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 12, bottom: 6),
            child: StatisticsIosHeading(
              stat: stat,
              onTap: stat.stats.length > displayCount
                  ? () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => BlocProvider.value(
                      //       value: _statisticsBloc,
                      //       child: IndividualStatisticPage(
                      //         server: _server,
                      //         statIdType: stat.statIdType,
                      //       ),
                      //     ),
                      //   ),
                      // );
                    }
                  : null,
            ),
          ),
        );

        // Limit displayed items to 5
        for (var j = 0; j < displayCount; j++) {
          final StatisticDataModel statData = stat.stats[j];

          late MediaType? mediaType;
          switch (statData.mediaType) {
            case MediaType.album:
              mediaType = MediaType.artist;
              break;
            case MediaType.episode:
              mediaType = MediaType.show;
              break;
            case MediaType.season:
              mediaType = MediaType.show;
              break;
            case MediaType.track:
              mediaType = MediaType.artist;
              break;
            default:
              mediaType = statData.mediaType;
              break;
          }

          final media = MediaModel(
            grandparentRatingKey: statData.grandparentRatingKey,
            grandparentTitle: statData.grandparentTitle,
            imageUri: statData.posterUri,
            // live: statData.live,
            mediaIndex: statData.mediaIndex,
            mediaType: mediaType,
            parentMediaIndex: statData.parentMediaIndex,
            // parentRatingKey: statData.parentRatingKey,
            // parentTitle: statData.parentTitle,
            ratingKey: statData.ratingKey,
            title: statData.title,
            year: statData.year,
          );

          if ([
            StatIdType.topTv,
            StatIdType.topMovies,
            StatIdType.topMusic,
          ].contains(stat.statIdType)) {
            widgetList.add(
              IosPosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: TopStatisticIosDetails(statData: statData),
                onTap: () async {
                  // await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => MediaPage(
                  //       server: _server,
                  //       media: media,
                  //     ),
                  //   ),
                  // );
                },
              ),
            );
          }

          if ([
            StatIdType.popularTv,
            StatIdType.popularMovies,
            StatIdType.popularMusic,
          ].contains(stat.statIdType)) {
            widgetList.add(
              IosPosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticIosDetails(statData: statData),
                onTap: () async {
                  // await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => MediaPage(
                  //       server: _server,
                  //       media: media,
                  //     ),
                  //   ),
                  // );
                },
              ),
            );
          }

          if (stat.statIdType == StatIdType.lastWatched) {
            widgetList.add(
              IosPosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticIosDetails(statData: statData),
                onTap: () async {
                  // await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => MediaPage(
                  //       server: _server,
                  //       media: media.copyWith(mediaType: statData.mediaType),
                  //     ),
                  //   ),
                  // );
                },
              ),
            );
          }

          if (stat.statIdType == StatIdType.topUsers) {
            widgetList.add(
              UserIosCard(
                server: _server,
                user: UserTableModel(
                  userId: statData.userId,
                  lastSeen: statData.lastPlay,
                  friendlyName: statData.friendlyName,
                  userThumb: statData.userThumb,
                ),
                details: TopUsersStatisticIosDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.topPlatforms) {
            widgetList.add(
              IosIconCard(
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withValues(alpha: 0.6),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: TautulliColorPalette.mapPlatformToColor(
                        statData.platformName!,
                      ),
                    ),
                  ),
                ),
                icon: WebsafeSvg.asset(
                  AssetHelper.mapPlatformToPath(statData.platformName!),
                  colorFilter: ColorFilter.mode(
                    ThemeHelper.cupertinoCardIconColor(),
                    BlendMode.srcIn,
                  ),
                ),
                details: TopPlatformsStatisticIosDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.mostConcurrent) {
            widgetList.add(
              IosIconCard(
                icon: WebsafeSvg.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticIosDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.topLibraries) {
            widgetList.add(
              LibraryIosCard(
                library: LibraryTableModel(
                  iconUri: statData.iconUri,
                  sectionId: statData.sectionId,
                  sectionType: statData.sectionType,
                  sectionName: statData.sectionName,
                  thumb: statData.thumb,
                  backgroundUri: statData.posterUri,
                  lastAccessed: statData.lastPlay,
                  isActive: true,
                ),
                details: TopLibrariesStatisticIosDetails(statData: statData),
              ),
            );
          }

          widgetList.add(const Gap(8));
        }
      }
    }

    return widgetList;
  }

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Icon(
            _statsType == PlayMetricType.plays ? CupertinoIcons.number : CupertinoIcons.clock_fill,
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
          ),
          onPressed: () async {
            final result = await showCupertinoSheet(
              context: context,
              builder: (_) => StatisticTypeIosBottomSheet(
                initialValue: _statsType,
              ),
            );

            if (result != null && result != _statsType) {
              setState(() {
                _statsType = result;
              });

              _settingsBloc.add(
                SettingsUpdateStatisticsStatType(_statsType),
              );

              _filterRefresh = true;

              _statisticsBloc.add(
                StatisticsFetched(
                  server: _server,
                  timeRange: _timeRange,
                  statsType: _statsType,
                  freshFetch: true,
                  settingsBloc: _settingsBloc,
                ),
              );
            }
          },
        ),
        Stack(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              child: Icon(
                CupertinoIcons.calendar,
                color: ThemeHelper.cupertinoNavigationBarItemColor(),
              ),
              onPressed: () async {
                final result = await showCupertinoSheet(
                  context: context,
                  builder: (_) => TimeRangeIosBottomSheet(
                    initialValue: _timeRange,
                  ),
                );

                if (result != null && result != _timeRange) {
                  setState(() {
                    _timeRange = result;
                  });

                  _settingsBloc.add(
                    SettingsUpdateStatisticsTimeRange(_timeRange),
                  );

                  _filterRefresh = true;

                  _statisticsBloc.add(
                    StatisticsFetched(
                      server: _server,
                      timeRange: _timeRange,
                      statsType: _statsType,
                      freshFetch: true,
                      settingsBloc: _settingsBloc,
                    ),
                  );
                }
              },
            ),
            Positioned(
              bottom: 5,
              right: 6,
              child: IgnorePointer(
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _timeRange < 100 ? _timeRange.toString() : '99+',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _timeRange < 100 ? 10 : 9,
                        color: CupertinoTheme.of(context).primaryContrastingColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
