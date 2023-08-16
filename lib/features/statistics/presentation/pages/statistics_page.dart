import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/asset_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../graphs/presentation/widgets/custom_time_range_dialog.dart';
import '../../../libraries/data/models/library_table_model.dart';
import '../../../libraries/presentation/widgets/library_card.dart';
import '../../../media/data/models/media_model.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/data/models/user_table_model.dart';
import '../../../users/presentation/widgets/user_card.dart';
import '../../data/models/statistic_data_model.dart';
import '../../data/models/statistic_model.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/last_watched_statistic_detials.dart';
import '../widgets/most_concurrent_statistic_details.dart';
import '../widgets/popular_statistic_details.dart';
import '../widgets/statistics_heading.dart';
import '../widgets/top_libraries_statistic_details.dart';
import '../widgets/top_platforms_statistic_details.dart';
import '../widgets/top_statistic_details.dart';
import '../widgets/top_users_statistic_details.dart';
import 'individual_statistic_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  static const routeName = '/statistics';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<StatisticsBloc>(),
      child: const StatisticsView(),
    );
  }
}

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  late ServerModel _server;
  late PlayMetricType _statsType;
  late int _timeRange;
  late StatisticsBloc _statisticsBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _statisticsBloc = context.read<StatisticsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;
    _statsType = settingsState.appSettings.statisticsStatType;
    _timeRange = settingsState.appSettings.statisticsTimeRange;

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
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;

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
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.statistics_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            List<Widget> statsListWidgets = _buildStatListWidgets(state.statList);

            return PageBody(
              loading: state.status == BlocStatus.initial,
              child: ThemedRefreshIndicator(
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

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (statsListWidgets.isEmpty) {
                      if (state.status == BlocStatus.failure) {
                        return StatusPage(
                          scrollable: true,
                          message: state.message ?? '',
                          suggestion: state.suggestion ?? '',
                        );
                      }
                      if (state.status == BlocStatus.success) {
                        return StatusPage(
                          scrollable: true,
                          message: LocaleKeys.statistics_empty_message.tr(),
                        );
                      }
                    }

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      // Customized padding due to stat list widgets
                      padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                      children: statsListWidgets,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        tooltip: 'Stats Type',
        icon: FaIcon(
          _statsType == PlayMetricType.plays ? FontAwesomeIcons.hashtag : FontAwesomeIcons.solidClock,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
        onSelected: (PlayMetricType value) {
          setState(() {
            _statsType = value;
          });

          _settingsBloc.add(
            SettingsUpdateStatisticsStatType(_statsType),
          );

          _statisticsBloc.add(
            StatisticsFetched(
              server: _server,
              timeRange: _timeRange,
              statsType: _statsType,
              freshFetch: true,
              settingsBloc: _settingsBloc,
            ),
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: PlayMetricType.plays,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.hashtag,
                    size: 20,
                    color: _statsType == PlayMetricType.plays ? Theme.of(context).colorScheme.primary : null,
                  ),
                  const Gap(8),
                  Text(
                    LocaleKeys.play_count_title,
                    style: TextStyle(
                      color: _statsType == PlayMetricType.plays ? Theme.of(context).colorScheme.primary : null,
                    ),
                  ).tr(),
                ],
              ),
            ),
            PopupMenuItem(
              value: PlayMetricType.time,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidClock,
                    size: 20,
                    color: _statsType == PlayMetricType.time ? Theme.of(context).colorScheme.primary : null,
                  ),
                  const Gap(8),
                  Text(
                    LocaleKeys.play_time_title,
                    style: TextStyle(
                      color: _statsType == PlayMetricType.time ? Theme.of(context).colorScheme.primary : null,
                    ),
                  ).tr(),
                ],
              ),
            ),
          ];
        },
      ),
      Stack(
        children: [
          Center(
            child: PopupMenuButton(
              tooltip: LocaleKeys.time_range_title.tr(),
              icon: FaIcon(
                FontAwesomeIcons.solidCalendarDays,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              onSelected: (int value) async {
                if (value > 0) {
                  if (value != _timeRange) {
                    setState(() {
                      _timeRange = value;
                    });

                    _settingsBloc.add(
                      SettingsUpdateStatisticsTimeRange(_timeRange),
                    );

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
                } else {
                  final int timeRange = await showDialog(
                    context: context,
                    builder: (context) => const CustomTimeRangeDialog(),
                  );

                  if (timeRange != _timeRange) {
                    setState(() {
                      _timeRange = timeRange;
                    });

                    _settingsBloc.add(
                      SettingsUpdateStatisticsTimeRange(_timeRange),
                    );

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
                }
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 7,
                    child: Text(
                      '7 ${LocaleKeys.days_title.tr()}',
                      style: TextStyle(
                        color: _timeRange == 7 ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 14,
                    child: Text(
                      '14 ${LocaleKeys.days_title.tr()}',
                      style: TextStyle(
                        color: _timeRange == 14 ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 30,
                    child: Text(
                      '30 ${LocaleKeys.days_title.tr()}',
                      style: TextStyle(
                        color: _timeRange == 30 ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: -1,
                    child: Text(
                      'Custom',
                      style: TextStyle(
                        color: ![7, 14, 30].contains(_timeRange) ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                  ),
                ];
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 18,
                  width: 18,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Text(
                      _timeRange < 100 ? _timeRange.toString() : '99+',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _timeRange < 100 ? 10 : 8,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
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
            child: StatisticsHeading(
              stat: stat,
              onTap: stat.stats.length > displayCount
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _statisticsBloc,
                            child: IndividualStatisticPage(
                              server: _server,
                              statIdType: stat.statIdType,
                            ),
                          ),
                        ),
                      );
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
              PosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: TopStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MediaPage(
                        server: _server,
                        media: media,
                      ),
                    ),
                  );
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
              PosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MediaPage(
                        server: _server,
                        media: media,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (stat.statIdType == StatIdType.lastWatched) {
            widgetList.add(
              PosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MediaPage(
                        server: _server,
                        media: media.copyWith(mediaType: statData.mediaType),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (stat.statIdType == StatIdType.topUsers) {
            widgetList.add(
              UserCard(
                server: _server,
                user: UserTableModel(
                  userId: statData.userId,
                  lastSeen: statData.lastPlay,
                  friendlyName: statData.friendlyName,
                  userThumb: statData.userThumb,
                ),
                details: TopUsersStatisticDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.topPlatforms) {
            widgetList.add(
              IconCard(
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
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
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                details: TopPlatformsStatisticDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.mostConcurrent) {
            widgetList.add(
              IconCard(
                icon: WebsafeSvg.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.topLibraries) {
            widgetList.add(
              LibraryCard(
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
                details: TopLibrariesStatisticDetails(statData: statData),
              ),
            );
          }

          widgetList.add(const Gap(8));
        }
      }
    }

    return widgetList;
  }
}
