import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../core/widgets/user_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../libraries/domain/entities/library.dart';
import '../../../libraries/presentation/pages/library_details_page.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../domain/entities/statistics.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/statistics_details.dart';
import '../widgets/statistics_error_button.dart';
import '../widgets/statistics_heading.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

  static const routeName = '/statistics';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<StatisticsBloc>(),
      child: StatisticsPageContent(),
    );
  }
}

class StatisticsPageContent extends StatefulWidget {
  StatisticsPageContent({Key key}) : super(key: key);

  @override
  _StatisticsPageContentState createState() => _StatisticsPageContentState();
}

class _StatisticsPageContentState extends State<StatisticsPageContent> {
  final GlobalKey _timeRangeKey = GlobalKey();
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  StatisticsBloc _statisticsBloc;
  String _tautulliId;
  String _statsType;
  int _timeRange;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _statisticsBloc = context.read<StatisticsBloc>();

    final statisticsState = _statisticsBloc.state;
    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingsState.maskSensitiveInfo;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
      }

      if (statisticsState is StatisticsInitial) {
        _statsType = settingsState.statsType ?? 'plays';
        _timeRange = statisticsState.timeRange ?? 30;
      }

      _statisticsBloc.add(
        StatisticsFetch(
          tautulliId: _tautulliId,
          statsType: _statsType,
          timeRange: _timeRange,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: AppDrawerIcon(),
        title: Text('Statistics'),
        actions: _appBarActions(),
      ),
      drawer: AppDrawer(),
      body: DoubleTapExit(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoadSuccess) {
                  if (state.serverList.length > 1) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _tautulliId,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        items: state.serverList.map((server) {
                          return DropdownMenuItem(
                            child: ServerHeader(serverName: server.plexName),
                            value: server.tautulliId,
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != _tautulliId) {
                            setState(() {
                              _tautulliId = value;
                            });
                            _settingsBloc.add(
                              SettingsUpdateLastSelectedServer(
                                  tautulliId: _tautulliId),
                            );
                            _statisticsBloc.add(
                              StatisticsFilter(
                                tautulliId: value,
                                statsType: _statsType,
                                timeRange: _timeRange,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                }
                return Container(height: 0, width: 0);
              },
            ),
            BlocConsumer<StatisticsBloc, StatisticsState>(
              listener: (context, state) {
                if (state is StatisticsSuccess) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is StatisticsSuccess) {
                  List<Widget> statList = _buildStatisticList(
                    map: state.map,
                    hasReachedMaxMap: state.hasReachedMaxMap,
                  );

                  if (!state.noStats) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          _statisticsBloc.add(
                            StatisticsFilter(
                              tautulliId: _tautulliId,
                              statsType: _statsType,
                              timeRange: _timeRange,
                            ),
                          );
                          return _refreshCompleter.future;
                        },
                        child: Scrollbar(
                          child: ListView(
                            children: statList,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No stats to show for the selected period.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                }
                if (state is StatisticsFailure) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: ErrorMessage(
                              failure: state.failure,
                              message: state.message,
                              suggestion: state.suggestion,
                            ),
                          ),
                          StatisticsErrorButton(
                            completer: _refreshCompleter,
                            failure: state.failure,
                            statisticsAddedEvent: StatisticsFilter(
                              tautulliId: _tautulliId,
                              statsType: _statsType,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: FaIcon(
          _statsType == 'plays'
              ? FontAwesomeIcons.playCircle
              : FontAwesomeIcons.clock,
          size: 20,
          color: TautulliColorPalette.not_white,
        ),
        tooltip: 'Stats type',
        onSelected: (value) {
          if (value != _statsType) {
            setState(() {
              _statsType = value;
            });
            _settingsBloc.add(SettingsUpdateStatsType(statsType: _statsType));
            _statisticsBloc.add(
              StatisticsFilter(
                tautulliId: _tautulliId,
                statsType: _statsType,
                timeRange: _timeRange,
              ),
            );
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.playCircle,
                    size: 20,
                    color: _statsType == 'plays'
                        ? PlexColorPalette.gamboge
                        : TautulliColorPalette.not_white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Plays',
                      style: TextStyle(
                        color: _statsType == 'plays'
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                  ),
                ],
              ),
              value: 'plays',
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.clock,
                    size: 20,
                    color: _statsType == 'duration'
                        ? PlexColorPalette.gamboge
                        : TautulliColorPalette.not_white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Duration',
                      style: TextStyle(
                        color: _statsType == 'duration'
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                  ),
                ],
              ),
              value: 'duration',
            ),
          ];
        },
      ),
      Stack(
        children: [
          Center(
            child: PopupMenuButton(
              key: _timeRangeKey,
              icon: FaIcon(
                FontAwesomeIcons.calendarAlt,
                size: 20,
                color: TautulliColorPalette.not_white,
              ),
              tooltip: 'Time range',
              onSelected: (value) {
                if (_timeRange != value) {
                  if (value > 0) {
                    setState(() {
                      _timeRange = value;
                    });
                    _statisticsBloc.add(
                      StatisticsFilter(
                        tautulliId: _tautulliId,
                        statsType: _statsType,
                        timeRange: _timeRange,
                      ),
                    );
                  } else {
                    _buildCustomTimeRangeDialog();
                  }
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text(
                      '7 Days',
                      style: TextStyle(
                        color: _timeRange == 7
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: 7,
                  ),
                  PopupMenuItem(
                    child: Text(
                      '30 Days',
                      style: TextStyle(
                        color: _timeRange == 30
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: 30,
                  ),
                  PopupMenuItem(
                    child: Text(
                      '90 Days',
                      style: TextStyle(
                        color: _timeRange == 90
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: 90,
                  ),
                  PopupMenuItem(
                    child: Text(
                      [7, 30, 90].contains(_timeRange)
                          ? 'Custom'
                          : 'Custom ($_timeRange Days)',
                      style: TextStyle(
                        color: ![7, 30, 90].contains(_timeRange)
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: 0,
                  ),
                ];
              },
            ),
          ),
          Positioned(
            right: 5,
            top: 28,
            child: GestureDetector(
              onTap: () {
                dynamic state = _timeRangeKey.currentState;
                state.showButtonMenu();
              },
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PlexColorPalette.gamboge,
                ),
                child: Center(
                  child: Text(
                    _timeRange > 99 ? '99+' : _timeRange.toString(),
                    style: TextStyle(
                      fontSize: _timeRange > 99 ? 9 : 10,
                      fontWeight: FontWeight.w600,
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

  Future _buildCustomTimeRangeDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        final _customTimeRangeFormKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Custom Time Range'),
          content: Form(
            key: _customTimeRangeFormKey,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(hintText: 'Enter a time range in days'),
              validator: (value) {
                if (!isNumeric(value)) {
                  return 'Please enter an integer';
                } else if (int.tryParse(value) < 1) {
                  return 'Please enter an integer larger than 0';
                }

                setState(() {
                  _timeRange = int.parse(value);
                });

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("SAVE"),
              onPressed: () {
                if (_customTimeRangeFormKey.currentState.validate()) {
                  _statisticsBloc.add(
                    StatisticsFilter(
                      tautulliId: _tautulliId,
                      statsType: _statsType,
                      timeRange: _timeRange,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildStatisticList({
    @required Map<String, List<Statistics>> map,
    @required Map<String, bool> hasReachedMaxMap,
  }) {
    final List keys = map.keys.toList();
    List<Widget> statList = [];

    // Add extra padding to top of list if not multiserver
    final settingsState = _settingsBloc.state;
    if (settingsState is SettingsLoadSuccess) {
      if (settingsState.serverList.length < 2) {
        statList.add(const SizedBox(height: 9));
      }
    }

    List<String> statIds = [
      'top_tv',
      'popular_tv',
      'top_movies',
      'popular_movies',
      'top_music',
      'popular_music',
      'last_watched',
      'top_platforms',
      'top_users',
      'most_concurrent',
      'top_libraries',
    ];

    for (String key in keys) {
      if (map[key].isNotEmpty && statIds.contains(key)) {
        statList.addAll([
          BlocProvider<StatisticsBloc>.value(
            value: _statisticsBloc,
            child: StatisticsHeading(
              statId: key,
              statisticCount: map[key].length,
              tautulliId: _tautulliId,
              maskSensitiveInfo: _maskSensitiveInfo,
            ),
          ),
          Divider(
            indent: 8,
            endIndent: MediaQuery.of(context).size.width - 100,
            height: 7,
            thickness: 1,
            color: PlexColorPalette.gamboge,
          ),
          const SizedBox(height: 7),
        ]);
        for (int i = 0; i < 5; i++) {
          final Object heroTag = UniqueKey();

          if (i < map[key].length) {
            Statistics s = map[key][i];
            if (s.statId == 'top_platforms') {
              statList.add(
                IconCard(
                  localIconImagePath:
                      AssetMapperHelper.mapPlatformToPath(s.platformName),
                  backgroundColor:
                      TautulliColorPalette.mapPlatformToColor(s.platformName),
                  iconColor: TautulliColorPalette.not_white,
                  details: StatisticsDetails(
                    statistic: s,
                    maskSensitiveInfo: _maskSensitiveInfo,
                  ),
                ),
              );
            } else if (s.statId == 'top_users') {
              final user = UserTable(
                userId: s.userId,
                lastSeen: s.lastWatch,
                friendlyName: s.friendlyName,
                userThumb: s.userThumb,
              );

              statList.add(
                UserCard(
                  user: user,
                  details: StatisticsDetails(
                    statistic: s,
                    maskSensitiveInfo: _maskSensitiveInfo,
                  ),
                  maskSensitiveInfo: _maskSensitiveInfo,
                ),
              );
            } else if (s.statId == 'most_concurrent') {
              statList.add(
                IconCard(
                  localIconImagePath: 'assets/icons/concurrent.svg',
                  details: StatisticsDetails(
                    statistic: s,
                    maskSensitiveInfo: _maskSensitiveInfo,
                  ),
                ),
              );
            } else if (s.statId == 'top_libraries') {
              statList.add(
                GestureDetector(
                  onTap: () {
                    Library library = Library(
                      iconUrl: s.iconUrl,
                      backgroundUrl: s.posterUrl,
                      sectionId: s.sectionId,
                      sectionName: s.sectionName,
                      sectionType: s.sectionType,
                      plays: s.totalPlays,
                      duration: s.totalDuration,
                      libraryArt: s.art,
                      libraryThumb: s.thumb,
                      lastAccessed: s.lastWatch ?? -1,
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LibraryDetailsPage(
                          heroTag: s.sectionId,
                          library: library,
                          sectionType: library.sectionType,
                          ratingKey: s.ratingKey,
                          title: s.sectionName,
                        ),
                      ),
                    );
                  },
                  child: IconCard(
                    heroTag: s.sectionId,
                    localIconImagePath:
                        AssetMapperHelper.mapLibraryToPath(s.sectionType),
                    iconImageUrl: s.iconUrl,
                    backgroundImage: Image.network(s.posterUrl),
                    iconColor: TautulliColorPalette.not_white,
                    details: StatisticsDetails(
                      statistic: s,
                      maskSensitiveInfo: _maskSensitiveInfo,
                    ),
                  ),
                ),
              );
            } else {
              statList.add(
                GestureDetector(
                  onTap: () {
                    MediaItem mediaItem = MediaItem(
                      grandparentTitle: s.grandparentTitle,
                      parentMediaIndex: s.parentMediaIndex,
                      mediaIndex: s.mediaIndex,
                      mediaType: ['top_tv', 'popular_tv'].contains(s.statId)
                          ? 'show'
                          : ['top_music', 'popular_music'].contains(s.statId)
                              ? 'artist'
                              : s.mediaType,
                      posterUrl: s.posterUrl,
                      ratingKey: s.ratingKey,
                      title: s.mediaType == 'episode' &&
                              !['top_tv', 'popular_tv'].contains(s.statId)
                          ? s.grandchildTitle
                          : s.title,
                      year: s.year,
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MediaItemPage(
                          item: mediaItem,
                          heroTag: heroTag,
                          enableNavOptions: s.statId == 'last_watched',
                        ),
                      ),
                    );
                  },
                  child: PosterCard(
                    item: s,
                    details: StatisticsDetails(
                      statistic: s,
                      maskSensitiveInfo: _maskSensitiveInfo,
                    ),
                    heroTag: heroTag,
                  ),
                ),
              );
            }
          }
        }
        // Do not add spacing after last item in list
        if (keys.indexOf(key) < keys.length - 1) {
          statList.add(
            const SizedBox(height: 4),
          );
        }
      }
    }
    return statList;
  }
}
