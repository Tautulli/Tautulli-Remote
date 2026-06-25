import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/stat_id_type.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_bottom_loader.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_icon_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../libraries/data/models/library_table_model.dart';
import '../../../../libraries/presentation/widgets/cupertino/cupertino_style_library_card.dart';
import '../../../../media/presentation/pages/cupertino/cupertino_style_media_page.dart';
import '../../../../users/data/models/user_table_model.dart';
import '../../../../users/presentation/widgets/cupertino/cupertino_style_user_card.dart';
import '../../../data/models/statistic_model.dart';
import '../../bloc/statistics_bloc.dart';
import '../../../../../core/helpers/statistic_helper.dart';
import '../../widgets/base/last_watched_statistic_details.dart';
import '../../widgets/base/most_concurrent_statistic_details.dart';
import '../../widgets/base/popular_statistic_details.dart';
import '../../widgets/base/top_libraries_statistic_details.dart';
import '../../widgets/base/top_platforms_statistic_details.dart';
import '../../widgets/base/top_statistic_details.dart';
import '../../widgets/base/top_users_statistic_details.dart';

class CupertinoStyleIndividualStatisticPage extends StatelessWidget {
  final ServerModel server;
  final StatIdType statIdType;

  const CupertinoStyleIndividualStatisticPage({
    super.key,
    required this.server,
    required this.statIdType,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleIndividualStatisticView(
      server: server,
      statIdType: statIdType,
    );
  }
}

class CupertinoStyleIndividualStatisticView extends StatefulWidget {
  final ServerModel server;
  final StatIdType statIdType;

  const CupertinoStyleIndividualStatisticView({
    super.key,
    required this.server,
    required this.statIdType,
  });

  @override
  State<CupertinoStyleIndividualStatisticView> createState() => _CupertinoStyleIndividualStatisticViewState();
}

class _CupertinoStyleIndividualStatisticViewState extends State<CupertinoStyleIndividualStatisticView> {
  final _scrollController = ScrollController();
  late StatisticsBloc _statisticsBloc;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _statisticsBloc = context.read<StatisticsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
      previousPageTitle: LocaleKeys.statistics_title.tr(),
      middle: Text(StringHelper.mapStatIdTypeToString(widget.statIdType)),
      child: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          List<Widget> statsListWidgets = _buildStatListWidgets(
            state.statList.where((e) => e.statIdType == widget.statIdType).first,
          );

          return CupertinoScrollbar(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: state.hasReachedMaxMap[widget.statIdType] == true
                  ? statsListWidgets.length
                  : statsListWidgets.length + 1,
              separatorBuilder: (context, index) => const Gap(8),
              itemBuilder: (context, index) {
                if (index >= statsListWidgets.length) {
                  return CupertinoStyleBottomLoader(
                    status: state.status,
                    failure: state.failure,
                    message: state.message,
                    suggestion: state.suggestion,
                    onTap: () {
                      _statisticsBloc.add(
                        StatisticsFetchMore(
                          statIdType: widget.statIdType,
                        ),
                      );
                    },
                  );
                }

                return statsListWidgets[index];
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _statisticsBloc.add(
        StatisticsFetchMore(
          statIdType: widget.statIdType,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<Widget> _buildStatListWidgets(StatisticModel stat) {
    switch (stat.statIdType) {
      case (StatIdType.topTv):
      case (StatIdType.topMovies):
      case (StatIdType.topMusic):
        return stat.stats.map(
          (statData) {
            final media = buildMediaModelFromStatistic(
              statData,
              mediaTypeOverride: normalizeStatisticMediaType(statData.mediaType),
            );

            return CupertinoStylePosterCard(
              mediaType: statData.mediaType,
              uri: statData.posterUri,
              details: TopStatisticDetails(statData: statData),
              onTap: () async {
                await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CupertinoStyleMediaPage(
                      server: widget.server,
                      media: media,
                    ),
                  ),
                );
              },
            );
          },
        ).toList();
      case (StatIdType.popularTv):
      case (StatIdType.popularMovies):
      case (StatIdType.popularMusic):
        return stat.stats
            .map(
              (statData) => CupertinoStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleMediaPage(
                        server: widget.server,
                        media: buildMediaModelFromStatistic(
                          statData,
                          mediaTypeOverride: normalizeStatisticMediaType(statData.mediaType),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
            .toList();
      case (StatIdType.lastWatched):
        return stat.stats
            .map(
              (statData) => CupertinoStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleMediaPage(
                        server: widget.server,
                        media: buildMediaModelFromStatistic(statData),
                      ),
                    ),
                  );
                },
              ),
            )
            .toList();
      case (StatIdType.topUsers):
        return stat.stats
            .map(
              (statData) => CupertinoStyleUserCard(
                server: widget.server,
                user: UserTableModel(
                  userId: statData.userId,
                  lastSeen: statData.lastPlay,
                  friendlyName: statData.friendlyName,
                  userThumb: statData.userThumb,
                ),
                details: TopUsersStatisticDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.topPlatforms):
        return stat.stats
            .map(
              (statData) => CupertinoStyleIconCard(
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
            )
            .toList();
      case (StatIdType.mostConcurrent):
        return stat.stats
            .map(
              (statData) => CupertinoStyleIconCard(
                icon: SvgPicture.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.topLibraries):
        return stat.stats
            .map(
              (statData) => CupertinoStyleLibraryCard(
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
            )
            .toList();
      case (StatIdType.unknown):
        return [];
    }
  }
}
