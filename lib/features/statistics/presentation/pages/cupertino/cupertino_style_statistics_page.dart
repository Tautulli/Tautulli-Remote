import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/types/play_metric_type.dart';
import '../../../../../core/types/stat_id_type.dart';
import '../../../../../core/widgets/cupertino/bottom_sheets/cupertino_style_time_range_bottom_sheet.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_icon_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../libraries/data/models/library_table_model.dart';
import '../../../../libraries/presentation/widgets/cupertino/cupertino_style_library_card.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/cupertino/cupertino_style_media_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_table_model.dart';
import '../../../../users/presentation/widgets/cupertino/cupertino_style_user_card.dart';
import '../../../data/models/statistic_data_model.dart';
import '../../../data/models/statistic_model.dart';
import '../../bloc/statistics_bloc.dart';
import '../../widgets/base/last_watched_statistic_details.dart';
import '../../widgets/base/most_concurrent_statistic_details.dart';
import '../../widgets/base/popular_statistic_details.dart';
import '../../widgets/base/top_libraries_statistic_details.dart';
import '../../widgets/base/top_platforms_statistic_details.dart';
import '../../widgets/base/top_statistic_details.dart';
import '../../widgets/base/top_users_statistic_details.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_statistic_type_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_statistics_heading.dart';
import 'cupertino_style_individual_statistic_page.dart';

class CupertinoStyleStatisticsPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleStatisticsPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  static const routeName = '/statistics';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<StatisticsBloc>(param1: context.read<SettingsBloc>()),
      child: CupertinoStyleStatisticsView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleStatisticsView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleStatisticsView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleStatisticsView> createState() => _CupertinoStyleStatisticsViewState();
}

class _CupertinoStyleStatisticsViewState extends State<CupertinoStyleStatisticsView> {
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
      ),
    );
  }

  @override
  void dispose() {
    if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    super.dispose();
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
            ),
          );
        }
      },
      child: CupertinoStylePageScaffold(
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
                  child: CupertinoStyleStatusPage(
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  ),
                );
              }
              if (state.status == BlocStatus.success) {
                return _statusWidget(
                  child: CupertinoStyleStatusPage(
                    message: LocaleKeys.statistics_empty_message.tr(),
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
              child: CupertinoStyleRefreshPage(
                scrollController: _scrollController,
                onRefresh: () {
                  _statisticsBloc.add(
                    StatisticsFetched(
                      server: _server,
                      timeRange: _timeRange,
                      statsType: _statsType,
                      freshFetch: true,
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
    return CupertinoStyleRefreshPage(
      onRefresh: () {
        _statisticsBloc.add(
          StatisticsFetched(
            server: _server,
            timeRange: _timeRange,
            statsType: _statsType,
            freshFetch: true,
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
            child: CupertinoStyleStatisticsHeading(
              stat: stat,
              onTap: stat.stats.length > displayCount
                  ? () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _statisticsBloc,
                            child: CupertinoStyleIndividualStatisticPage(
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
              CupertinoStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: TopStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleMediaPage(
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
              CupertinoStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleMediaPage(
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
              CupertinoStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleMediaPage(
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
              CupertinoStyleUserCard(
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
              CupertinoStyleIconCard(
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
                icon: SvgPicture.asset(
                  AssetHelper.mapPlatformToPath(statData.platformName!),
                  colorFilter: const ColorFilter.mode(
                    ThemeHelper.cupertinoCardIconColor,
                    BlendMode.srcIn,
                  ),
                ),
                details: TopPlatformsStatisticDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.mostConcurrent) {
            widgetList.add(
              CupertinoStyleIconCard(
                icon: SvgPicture.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticDetails(statData: statData),
              ),
            );
          }

          if (stat.statIdType == StatIdType.topLibraries) {
            widgetList.add(
              CupertinoStyleLibraryCard(
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

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Icon(
            _statsType == PlayMetricType.plays ? CupertinoIcons.number : CupertinoIcons.clock_fill,
            color: ThemeHelper.cupertinoNavigationBarItemColor,
          ),
          onPressed: () async {
            final result = await showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoStyleStatisticTypeBottomSheet(
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
                ),
              );
            }
          },
        ),
        Stack(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                CupertinoIcons.calendar,
                color: ThemeHelper.cupertinoNavigationBarItemColor,
              ),
              onPressed: () async {
                final result = await showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoStyleTimeRangeBottomSheet(
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
