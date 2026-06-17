import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/types/stat_id_type.dart';
import '../../../../../core/widgets/material/material_style_bottom_loader.dart';
import '../../../../../core/widgets/material/material_style_icon_card.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_poster_card.dart';
import '../../../../libraries/data/models/library_table_model.dart';
import '../../../../libraries/presentation/widgets/material/material_style_library_card.dart';
import '../../../../media/presentation/pages/material/material_style_media_page.dart';
import '../../../../users/data/models/user_table_model.dart';
import '../../../../users/presentation/widgets/material/material_style_user_card.dart';
import '../../../data/models/statistic_model.dart';
import '../../bloc/statistics_bloc.dart';
import '../../../../../core/helpers/statistic_helper.dart';
import '../../widgets/base/last_watched_statistic_detials.dart';
import '../../widgets/base/most_concurrent_statistic_details.dart';
import '../../widgets/base/popular_statistic_details.dart';
import '../../widgets/base/top_libraries_statistic_details.dart';
import '../../widgets/base/top_platforms_statistic_details.dart';
import '../../widgets/base/top_statistic_details.dart';
import '../../widgets/base/top_users_statistic_details.dart';

class MaterialStyleIndividualStatisticPage extends StatelessWidget {
  final ServerModel server;
  final StatIdType statIdType;

  const MaterialStyleIndividualStatisticPage({
    super.key,
    required this.server,
    required this.statIdType,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleIndividualStatisticView(
      server: server,
      statIdType: statIdType,
    );
  }
}

class MaterialStyleIndividualStatisticView extends StatefulWidget {
  final ServerModel server;
  final StatIdType statIdType;

  const MaterialStyleIndividualStatisticView({
    super.key,
    required this.server,
    required this.statIdType,
  });

  @override
  State<MaterialStyleIndividualStatisticView> createState() => _MaterialStyleIndividualStatisticViewState();
}

class _MaterialStyleIndividualStatisticViewState extends State<MaterialStyleIndividualStatisticView> {
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
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(StringHelper.mapStatIdTypeToString(widget.statIdType)),
      ),
      body: MaterialStylePageBody(
        child: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            List<Widget> statsListWidgets = _buildStatListWidgets(
              state.statList.where((e) => e.statIdType == widget.statIdType).first,
            );

            return ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: state.hasReachedMaxMap[widget.statIdType] == true
                  ? statsListWidgets.length
                  : statsListWidgets.length + 1,
              separatorBuilder: (context, index) => const Gap(8),
              itemBuilder: (context, index) {
                if (index >= statsListWidgets.length) {
                  return MaterialStyleBottomLoader(
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
            );
          },
        ),
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

            return MaterialStylePosterCard(
              mediaType: statData.mediaType,
              uri: statData.posterUri,
              details: TopStatisticDetails(
                statData: statData,
                textColor: Theme.of(context).colorScheme.onSurface,
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MaterialStyleMediaPage(
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
              (statData) => MaterialStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticDetails(
                  statData: statData,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MaterialStyleMediaPage(
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
              (statData) => MaterialStylePosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticDetails(
                  statData: statData,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MaterialStyleMediaPage(
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
              (statData) => MaterialStyleUserCard(
                server: widget.server,
                user: UserTableModel(
                  userId: statData.userId,
                  lastSeen: statData.lastPlay,
                  friendlyName: statData.friendlyName,
                  userThumb: statData.userThumb,
                ),
                details: TopUsersStatisticDetails(
                  statData: statData,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
            .toList();
      case (StatIdType.topPlatforms):
        return stat.stats
            .map(
              (statData) => MaterialStyleIconCard(
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
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
                details: TopPlatformsStatisticDetails(
                  statData: statData,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
            .toList();
      case (StatIdType.mostConcurrent):
        return stat.stats
            .map(
              (statData) => MaterialStyleIconCard(
                icon: WebsafeSvg.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticDetails(
                  statData: statData,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
            .toList();
      case (StatIdType.topLibraries):
        return stat.stats
            .map(
              (statData) => MaterialStyleLibraryCard(
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
                details: TopLibrariesStatisticDetails(
                  statData: statData,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
            .toList();
      case (StatIdType.unknown):
        return [];
    }
  }
}
