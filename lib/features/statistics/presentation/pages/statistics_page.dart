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
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  StatisticsBloc _statisticsBloc;
  String _tautulliId;
  String _statsType = 'plays';
  int _timeRange = 30;
  bool _statisticsLoaded = false;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _statisticsBloc = context.bloc<StatisticsBloc>();

    final state = _settingsBloc.state;

    if (state is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (state.lastSelectedServer != null) {
        for (Server server in state.serverList) {
          if (server.tautulliId == state.lastSelectedServer) {
            lastSelectedServer = state.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (state.serverList.length > 0) {
        setState(() {
          _tautulliId = state.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
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
                List<Widget> statList = _buildStatisticList(map: state.map);

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
      BlocListener<StatisticsBloc, StatisticsState>(
        listener: (context, state) {
          if (state is StatisticsSuccess) {
            setState(() {
              _statisticsLoaded = true;
            });
          } else {
            setState(() {
              _statisticsLoaded = false;
            });
          }
        },
        child: PopupMenuButton(
          icon: FaIcon(
            _statsType == 'plays'
                ? FontAwesomeIcons.playCircle
                : FontAwesomeIcons.clock,
            color: !_statisticsLoaded
                ? Theme.of(context).disabledColor
                : TautulliColorPalette.not_white,
          ),
          tooltip: 'Stats type',
          enabled: _statisticsLoaded,
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
                      color: _statsType == 'plays'
                          ? PlexColorPalette.gamboge
                          : TautulliColorPalette.not_white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
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
                      color: _statsType == 'duration'
                          ? PlexColorPalette.gamboge
                          : TautulliColorPalette.not_white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
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
      ),
      PopupMenuButton(
        icon: FaIcon(
          FontAwesomeIcons.calendarAlt,
          color: !_statisticsLoaded
              ? Theme.of(context).disabledColor
              : TautulliColorPalette.not_white,
        ),
        tooltip: 'Time range',
        enabled: _statisticsLoaded,
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
                _timeRange = int.parse(value);
                return null;
              },
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Save"),
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
  }) {
    final List keys = map.keys.toList();
    List<Widget> statList = [];

    for (String key in keys) {
      if (map[key].isEmpty) {
        break;
      }
      statList.add(
        StatisticsHeading(statId: key),
      );
      for (Statistics s in map[key]) {
        if (s.statId == 'top_platforms') {
          statList.add(
            IconCard(
              assetPath: AssetMapperHelper().mapPlatformToPath(s.platformName),
              backgroundColor:
                  TautulliColorPalette().mapPlatformToColor(s.platformName),
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
      statList.add(
        const SizedBox(height: 8),
      );
    }

    return statList;
  }
}
