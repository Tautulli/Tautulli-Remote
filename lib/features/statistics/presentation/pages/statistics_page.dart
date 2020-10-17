import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../core/widgets/user_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _statisticsBloc = context.bloc<StatisticsBloc>();

    final statisticsState = _statisticsBloc.state;
    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

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
        _statsType = statisticsState.statsType ?? 'plays';
        _timeRange = statisticsState.timeRange ?? 30;
      }

      _statisticsBloc.add(
        StatisticsFetch(
          tautulliId: _tautulliId,
          statsType: _statsType,
          timeRange: _timeRange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Statistics'),
        actions: _appBarActions(),
      ),
      drawer: AppDrawer(),
      body: Column(
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
                  child: Column(
                    children: [
                      Expanded(child: const SizedBox()),
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
                      Expanded(child: const SizedBox()),
                    ],
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
          setState(() {
            _statsType = value;
          });
          _statisticsBloc.add(
            StatisticsFilter(
              tautulliId: _tautulliId,
              statsType: _statsType,
              timeRange: _timeRange,
            ),
          );
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
            FlatButton(
              child: Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
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
        statList.add(const SizedBox(height: 15));
      }
    }

    for (String key in keys) {
      if (map[key].isNotEmpty) {
        statList.addAll([
          BlocProvider<StatisticsBloc>.value(
            value: _statisticsBloc,
            child: StatisticsHeading(
              statId: key,
              statisticCount: map[key].length,
              tautulliId: _tautulliId,
            ),
          ),
          Divider(
            indent: 8,
            endIndent: MediaQuery.of(context).size.width - 100,
            height: 15,
            thickness: 1,
            color: PlexColorPalette.gamboge,
          ),
        ]);
        for (int i = 0; i < 5; i++) {
          if (i < map[key].length) {
            Statistics s = map[key][i];
            if (s.statId == 'top_platforms') {
              statList.add(
                IconCard(
                  assetPath:
                      AssetMapperHelper.mapPlatformToPath(s.platformName),
                  backgroundColor:
                      TautulliColorPalette.mapPlatformToColor(s.platformName),
                  details: StatisticsDetails(statistic: s),
                ),
              );
            } else if (s.statId == 'top_users') {
              statList.add(
                UserCard(
                  userThumb: s.userThumb,
                  details: StatisticsDetails(statistic: s),
                ),
              );
            } else if (s.statId == 'most_concurrent') {
              statList.add(
                IconCard(
                  assetPath: 'assets/icons/concurrent.svg',
                  details: StatisticsDetails(statistic: s),
                ),
              );
            } else {
              statList.add(
                PosterCard(
                  item: s,
                  details: StatisticsDetails(statistic: s),
                ),
              );
            }
          }
        }
        // Do not add spacing after last item in list
        if (keys.indexOf(key) < keys.length - 1) {
          statList.add(
            const SizedBox(height: 18),
          );
        }
      }
    }
    return statList;
  }
}
