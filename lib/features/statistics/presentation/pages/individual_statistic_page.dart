import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/asset_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/types/stat_id_type.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../libraries/data/models/library_table_model.dart';
import '../../../libraries/presentation/widgets/library_card.dart';
import '../../../media/data/models/media_model.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/data/models/user_table_model.dart';
import '../../../users/presentation/widgets/user_card.dart';
import '../../data/models/statistic_model.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/last_watched_statistic_detials.dart';
import '../widgets/most_concurrent_statistic_details.dart';
import '../widgets/popular_statistic_details.dart';
import '../widgets/top_libraries_statistic_details.dart';
import '../widgets/top_platforms_statistic_details.dart';
import '../widgets/top_statistic_details.dart';
import '../widgets/top_users_statistic_details.dart';

class IndividualStatisticPage extends StatelessWidget {
  final StatIdType statIdType;

  const IndividualStatisticPage({
    super.key,
    required this.statIdType,
  });

  @override
  Widget build(BuildContext context) {
    return IndividualStatisticView(statIdType: statIdType);
  }
}

class IndividualStatisticView extends StatefulWidget {
  final StatIdType statIdType;

  const IndividualStatisticView({
    super.key,
    required this.statIdType,
  });

  @override
  State<IndividualStatisticView> createState() => _IndividualStatisticViewState();
}

class _IndividualStatisticViewState extends State<IndividualStatisticView> {
  final _scrollController = ScrollController();
  late StatisticsBloc _statisticsBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _statisticsBloc = context.read<StatisticsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.mapStatIdTypeToString(widget.statIdType)),
      ),
      body: PageBody(
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
                  return BottomLoader(
                    status: state.status,
                    failure: state.failure,
                    message: state.message,
                    suggestion: state.suggestion,
                    onTap: () {
                      _statisticsBloc.add(
                        StatisticsFetchMore(
                          statIdType: widget.statIdType,
                          settingsBloc: _settingsBloc,
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
          settingsBloc: _settingsBloc,
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

            return PosterCard(
              mediaType: statData.mediaType,
              uri: statData.posterUri,
              details: TopStatisticDetails(statData: statData),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MediaPage(
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
              (statData) => PosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
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

                        return MediaPage(
                          media: media,
                        );
                      },
                    ),
                  );
                },
              ),
            )
            .toList();
      case (StatIdType.lastWatched):
        return stat.stats
            .map(
              (statData) => PosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        final media = MediaModel(
                          grandparentRatingKey: statData.grandparentRatingKey,
                          grandparentTitle: statData.grandparentTitle,
                          imageUri: statData.posterUri,
                          // live: statData.live,
                          mediaIndex: statData.mediaIndex,
                          mediaType: statData.mediaType,
                          parentMediaIndex: statData.parentMediaIndex,
                          // parentRatingKey: statData.parentRatingKey,
                          // parentTitle: statData.parentTitle,
                          ratingKey: statData.ratingKey,
                          title: statData.title,
                          year: statData.year,
                        );

                        return MediaPage(
                          media: media,
                        );
                      },
                    ),
                  );
                },
              ),
            )
            .toList();
      case (StatIdType.topUsers):
        return stat.stats
            .map(
              (statData) => UserCard(
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
              (statData) => IconCard(
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
                ),
                details: TopPlatformsStatisticDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.mostConcurrent):
        return stat.stats
            .map(
              (statData) => IconCard(
                icon: WebsafeSvg.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.topLibraries):
        return stat.stats
            .map(
              (statData) => LibraryCard(
                library: LibraryTableModel(
                  iconUri: statData.iconUri,
                  sectionId: statData.sectionId,
                  sectionType: statData.sectionType,
                  sectionName: statData.sectionName,
                  thumb: statData.thumb,
                  backgroundUri: statData.posterUri,
                  lastAccessed: statData.lastPlay,
                ),
                details: TopLibrariesStatisticDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.unknown):
      default: //TODO: Remove when Dart stops thinking default is needed even when all enum types are accounted for
        return [];
    }
  }
}
