// @dart=2.9

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/inherited_headers.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/user_card.dart';
import '../../../libraries/domain/entities/library.dart';
import '../../../libraries/presentation/pages/library_details_page.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../domain/entities/statistics.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/statistics_details.dart';

class SingleStatisticTypePage extends StatefulWidget {
  final String statId;
  final String tautulliId;
  final bool maskSensitiveInfo;

  const SingleStatisticTypePage({
    Key key,
    @required this.statId,
    @required this.tautulliId,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  _SingleStatisticTypePageState createState() =>
      _SingleStatisticTypePageState();
}

class _SingleStatisticTypePageState extends State<SingleStatisticTypePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  StatisticsBloc _statisticsBloc;
  SettingsBloc _settingsBloc;
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _statisticsBloc = context.read<StatisticsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsLoadSuccess;

    StatisticsState statisticsState = _statisticsBloc.state;

    if (settingsState.lastSelectedServer != null) {
      for (Server server in settingsState.serverList) {
        if (server.tautulliId == settingsState.lastSelectedServer) {
          for (CustomHeaderModel header in server.customHeaders) {
            headerMap[header.key] = header.value;
          }

          break;
        }
      }
    }

    if (settingsState.serverList.isNotEmpty) {
      setState(() {
        for (CustomHeaderModel header
            in settingsState.serverList[0].customHeaders) {
          headerMap[header.key] = header.value;
        }
      });
    }

    if (statisticsState is StatisticsSuccess) {
      if (!statisticsState.hasReachedMaxMap[widget.statId]) {
        _statisticsBloc.add(
          StatisticsFetch(
            tautulliId: widget.tautulliId,
            statId: widget.statId,
            settingsBloc: _settingsBloc,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(StringMapperHelper.mapStatIdToTitle(widget.statId)),
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsSuccess) {
            List<Statistics> statisticList = state.map[widget.statId];
            bool hasReachedMax = state.hasReachedMaxMap[widget.statId];

            return InheritedHeaders(
              headerMap: headerMap,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: hasReachedMax
                      ? statisticList.length
                      : statisticList.length + 1,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index >= statisticList.length) {
                      return BottomLoader();
                    }

                    final Object heroTag = UniqueKey();
                    final Statistics stat = statisticList[index];

                    if (widget.statId == 'top_platforms') {
                      return IconCard(
                        localIconImagePath: AssetMapperHelper.mapPlatformToPath(
                          stat.platformName,
                        ),
                        backgroundColor:
                            TautulliColorPalette.mapPlatformToColor(
                          stat.platformName,
                        ),
                        iconColor: TautulliColorPalette.not_white,
                        details: StatisticsDetails(
                          statistic: stat,
                          maskSensitiveInfo: widget.maskSensitiveInfo,
                        ),
                      );
                    } else if (widget.statId == 'top_users') {
                      final user = UserTable(
                        userId: stat.userId,
                        lastSeen: stat.lastWatch,
                        friendlyName: stat.friendlyName,
                        userThumb: stat.userThumb,
                      );

                      return UserCard(
                        user: user,
                        details: StatisticsDetails(
                          statistic: stat,
                          maskSensitiveInfo: widget.maskSensitiveInfo,
                        ),
                        maskSensitiveInfo: widget.maskSensitiveInfo,
                      );
                    } else if (widget.statId == 'most_concurrent') {
                      return IconCard(
                        localIconImagePath: 'assets/icons/concurrent.svg',
                        details: StatisticsDetails(
                          statistic: stat,
                          maskSensitiveInfo: widget.maskSensitiveInfo,
                        ),
                      );
                    } else if (widget.statId == 'top_libraries') {
                      return GestureDetector(
                        onTap: () {
                          Library library = Library(
                            iconUrl: stat.iconUrl,
                            backgroundUrl: stat.posterUrl,
                            sectionId: stat.sectionId,
                            sectionName: stat.sectionName,
                            sectionType: stat.sectionType,
                            plays: stat.totalPlays,
                            duration: stat.totalDuration,
                            libraryArt: stat.art,
                            libraryThumb: stat.thumb,
                            lastAccessed: stat.lastWatch ?? -1,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LibraryDetailsPage(
                                library: library,
                                sectionType: library.sectionType,
                                ratingKey: stat.ratingKey,
                                title: stat.sectionName,
                              ),
                            ),
                          );
                        },
                        child: IconCard(
                          localIconImagePath:
                              AssetMapperHelper.mapLibraryToPath(
                                  stat.sectionType),
                          backgroundImage: Image(
                            image: CachedNetworkImageProvider(stat.posterUrl),
                          ),
                          iconColor: TautulliColorPalette.not_white,
                          details: StatisticsDetails(
                            statistic: stat,
                            maskSensitiveInfo: widget.maskSensitiveInfo,
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          MediaItem mediaItem = MediaItem(
                            grandparentTitle: stat.grandparentTitle,
                            parentMediaIndex: stat.parentMediaIndex,
                            mediaIndex: stat.mediaIndex,
                            mediaType:
                                ['top_tv', 'popular_tv'].contains(stat.statId)
                                    ? 'show'
                                    : ['top_music', 'popular_music']
                                            .contains(stat.statId)
                                        ? 'artist'
                                        : stat.mediaType,
                            posterUrl: stat.posterUrl,
                            ratingKey: stat.ratingKey,
                            title: stat.mediaType == 'episode' &&
                                    !['top_tv', 'popular_tv']
                                        .contains(stat.statId)
                                ? stat.grandchildTitle
                                : stat.title,
                            year: stat.year,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MediaItemPage(
                                item: mediaItem,
                                heroTag: heroTag,
                                enableNavOptions: stat.statId == 'last_watched',
                              ),
                            ),
                          );
                        },
                        child: PosterCard(
                          item: stat,
                          details: StatisticsDetails(
                            statistic: stat,
                            maskSensitiveInfo: widget.maskSensitiveInfo,
                          ),
                          heroTag: heroTag,
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).accentColor,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _statisticsBloc.add(
        StatisticsFetch(
          tautulliId: widget.tautulliId,
          statId: widget.statId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }
}
