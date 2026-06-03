import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/types/stat_id_type.dart';
import '../../../../../core/widgets/ios/ios_bottom_loader.dart';
import '../../../../../core/widgets/ios/ios_icon_card.dart';
import '../../../../../core/widgets/ios/ios_poster_card.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../libraries/data/models/library_table_model.dart';
import '../../../../libraries/presentation/widgets/ios/library_ios_card.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/ios/media_ios_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_table_model.dart';
import '../../../../users/presentation/widgets/ios/user_ios_card.dart';
import '../../../data/models/statistic_model.dart';
import '../../bloc/statistics_bloc.dart';
import '../../widgets/ios/last_watched_statistic_ios_details.dart';
import '../../widgets/ios/most_concurrent_statistic_ios_details.dart';
import '../../widgets/ios/popular_statistic_ios_details.dart';
import '../../widgets/ios/top_libraries_statistic_ios_details.dart';
import '../../widgets/ios/top_platforms_statistic_ios_details.dart';
import '../../widgets/ios/top_statistic_ios_details.dart';
import '../../widgets/ios/top_users_statistic_ios_details.dart';

class IndividualStatisticIosPage extends StatelessWidget {
  final ServerModel server;
  final StatIdType statIdType;

  const IndividualStatisticIosPage({
    super.key,
    required this.server,
    required this.statIdType,
  });

  @override
  Widget build(BuildContext context) {
    return IndividualStatisticIosView(
      server: server,
      statIdType: statIdType,
    );
  }
}

class IndividualStatisticIosView extends StatefulWidget {
  final ServerModel server;
  final StatIdType statIdType;

  const IndividualStatisticIosView({
    super.key,
    required this.server,
    required this.statIdType,
  });

  @override
  State<IndividualStatisticIosView> createState() => _IndividualStatisticIosViewState();
}

class _IndividualStatisticIosViewState extends State<IndividualStatisticIosView> {
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
    return PageScaffoldCupertino(
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
                  return IosBottomLoader(
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

            return IosPosterCard(
              mediaType: statData.mediaType,
              uri: statData.posterUri,
              details: TopStatisticIosDetails(statData: statData),
              onTap: () async {
                await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => MediaIosPage(
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
              (statData) => IosPosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: PopularStatisticIosDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
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

                        return MediaIosPage(
                          server: widget.server,
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
              (statData) => IosPosterCard(
                mediaType: statData.mediaType,
                uri: statData.posterUri,
                details: LastWatchedStatisticIosDetails(statData: statData),
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
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

                        return MediaIosPage(
                          server: widget.server,
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
              (statData) => UserIosCard(
                server: widget.server,
                user: UserTableModel(
                  userId: statData.userId,
                  lastSeen: statData.lastPlay,
                  friendlyName: statData.friendlyName,
                  userThumb: statData.userThumb,
                ),
                details: TopUsersStatisticIosDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.topPlatforms):
        return stat.stats
            .map(
              (statData) => IosIconCard(
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
            )
            .toList();
      case (StatIdType.mostConcurrent):
        return stat.stats
            .map(
              (statData) => IosIconCard(
                icon: WebsafeSvg.asset('assets/icons/concurrent.svg'),
                details: MostConcurrentStatisticIosDetails(statData: statData),
              ),
            )
            .toList();
      case (StatIdType.topLibraries):
        return stat.stats
            .map(
              (statData) => LibraryIosCard(
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
            )
            .toList();
      case (StatIdType.unknown):
        return [];
    }
  }
}
