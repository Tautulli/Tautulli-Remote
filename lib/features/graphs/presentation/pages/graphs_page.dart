import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/media_type_graphs_bloc.dart';
import '../bloc/play_totals_graphs_bloc.dart';
import '../bloc/stream_type_graphs_bloc.dart';
import '../widgets/media_type_tab.dart';
import '../widgets/play_totals_tab.dart';
import '../widgets/stream_type_tab.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({Key key}) : super(key: key);

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MediaTypeGraphsBloc>(
          create: (context) => di.sl<MediaTypeGraphsBloc>(),
        ),
        BlocProvider<StreamTypeGraphsBloc>(
          create: (context) => di.sl<StreamTypeGraphsBloc>(),
        ),
        BlocProvider<PlayTotalsGraphsBloc>(
          create: (context) => di.sl<PlayTotalsGraphsBloc>(),
        ),
      ],
      child: _GraphsPageContent(),
    );
  }
}

class _GraphsPageContent extends StatefulWidget {
  _GraphsPageContent({Key key}) : super(key: key);

  @override
  __GraphsPageContentState createState() => __GraphsPageContentState();
}

class __GraphsPageContentState extends State<_GraphsPageContent> {
  final GlobalKey _timeRangeKey = GlobalKey();
  SettingsBloc _settingsBloc;
  MediaTypeGraphsBloc _mediaTypeGraphsBloc;
  StreamTypeGraphsBloc _streamTypeGraphsBloc;
  PlayTotalsGraphsBloc _playTotalsGraphsBloc;
  String _tautulliId;
  int _timeRange;
  String _yAxis;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _mediaTypeGraphsBloc = context.read<MediaTypeGraphsBloc>();
    _streamTypeGraphsBloc = context.read<StreamTypeGraphsBloc>();
    _playTotalsGraphsBloc = context.read<PlayTotalsGraphsBloc>();

    final mediaTypeGraphsState = _mediaTypeGraphsBloc.state;
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
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        setState(() {
          _tautulliId = null;
        });
      }

      if (mediaTypeGraphsState is MediaTypeGraphsInitial) {
        _yAxis = settingsState.yAxis;
        _timeRange = mediaTypeGraphsState.timeRange ?? 30;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          LocaleKeys.graphs_page_title.tr(),
        ),
        leading: const AppDrawerIcon(),
        actions: _appBarActions(),
      ),
      drawer: const AppDrawer(),
      body: DoubleTapExit(
        child: SafeArea(
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
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
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
                                  tautulliId: _tautulliId,
                                ),
                              );
                              _mediaTypeGraphsBloc.add(
                                MediaTypeGraphsFetch(
                                  tautulliId: value,
                                  timeRange: _timeRange,
                                  yAxis: _yAxis,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                              _streamTypeGraphsBloc.add(
                                StreamTypeGraphsFetch(
                                  tautulliId: value,
                                  timeRange: _timeRange,
                                  yAxis: _yAxis,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                              _playTotalsGraphsBloc.add(
                                PlayTotalsGraphsFetch(
                                  tautulliId: value,
                                  // timeRange: _timeRange,
                                  yAxis: _yAxis,
                                  settingsBloc: _settingsBloc,
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
              DefaultTabController(
                length: 3,
                child: Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            BlocProvider.value(
                              value: _mediaTypeGraphsBloc,
                              child: MediaTypeTab(
                                tautulliId: _tautulliId,
                                timeRange: _timeRange,
                                yAxis: _yAxis,
                              ),
                            ),
                            BlocProvider.value(
                              value: _streamTypeGraphsBloc,
                              child: StreamTypeTab(
                                tautulliId: _tautulliId,
                                timeRange: _timeRange,
                                yAxis: _yAxis,
                              ),
                            ),
                            BlocProvider.value(
                              value: _playTotalsGraphsBloc,
                              child: PlayTotalsTab(
                                tautulliId: _tautulliId,
                                // timeRange: _timeRange,
                                yAxis: _yAxis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            child: const Text(LocaleKeys.graphs_media_type_tab)
                                .tr(),
                          ),
                          Tab(
                            child: const Text(LocaleKeys.graphs_stream_type_tab)
                                .tr(),
                          ),
                          Tab(
                            child: const Text(LocaleKeys.graphs_play_totals_tab)
                                .tr(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: FaIcon(
          _yAxis == 'plays'
              ? FontAwesomeIcons.playCircle
              : FontAwesomeIcons.clock,
          size: 20,
          color: TautulliColorPalette.not_white,
        ),
        tooltip: LocaleKeys.general_tooltip_y_axis.tr(),
        onSelected: (value) {
          if (value != _yAxis) {
            setState(() {
              _yAxis = value;
            });
            _settingsBloc.add(SettingsUpdateYAxis(yAxis: _yAxis));
            _mediaTypeGraphsBloc.add(
              MediaTypeGraphsFetch(
                tautulliId: _tautulliId,
                timeRange: _timeRange,
                yAxis: _yAxis,
                settingsBloc: _settingsBloc,
              ),
            );
            _streamTypeGraphsBloc.add(
              StreamTypeGraphsFetch(
                tautulliId: _tautulliId,
                timeRange: _timeRange,
                yAxis: _yAxis,
                settingsBloc: _settingsBloc,
              ),
            );
            _playTotalsGraphsBloc.add(
              PlayTotalsGraphsFetch(
                tautulliId: _tautulliId,
                // timeRange: _timeRange,
                yAxis: _yAxis,
                settingsBloc: _settingsBloc,
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
                    color: _yAxis == 'plays'
                        ? PlexColorPalette.gamboge
                        : TautulliColorPalette.not_white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      LocaleKeys.general_filter_plays,
                      style: TextStyle(
                        color: _yAxis == 'plays'
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ).tr(),
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
                    color: _yAxis == 'duration'
                        ? PlexColorPalette.gamboge
                        : TautulliColorPalette.not_white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      LocaleKeys.general_filter_duration,
                      style: TextStyle(
                        color: _yAxis == 'duration'
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ).tr(),
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
              icon: const FaIcon(
                FontAwesomeIcons.calendarAlt,
                size: 20,
                color: TautulliColorPalette.not_white,
              ),
              tooltip: LocaleKeys.general_tooltip_time_range.tr(),
              onSelected: (value) {
                if (_timeRange != value) {
                  if (value > 0) {
                    setState(() {
                      _timeRange = value;
                    });
                    _mediaTypeGraphsBloc.add(
                      MediaTypeGraphsFetch(
                        tautulliId: _tautulliId,
                        timeRange: _timeRange,
                        yAxis: _yAxis,
                        settingsBloc: _settingsBloc,
                      ),
                    );
                    _streamTypeGraphsBloc.add(
                      StreamTypeGraphsFetch(
                        tautulliId: _tautulliId,
                        timeRange: _timeRange,
                        yAxis: _yAxis,
                        settingsBloc: _settingsBloc,
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
                      '7 ${LocaleKeys.general_filter_days.tr()}',
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
                      '14 ${LocaleKeys.general_filter_days.tr()}',
                      style: TextStyle(
                        color: _timeRange == 14
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: 14,
                  ),
                  PopupMenuItem(
                    child: Text(
                      '30 ${LocaleKeys.general_filter_days.tr()}',
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
                      [7, 14, 30].contains(_timeRange)
                          ? LocaleKeys.general_filter_custom.tr()
                          : '${LocaleKeys.general_filter_custom.tr()} ($_timeRange ${LocaleKeys.general_filter_days.tr()})',
                      style: TextStyle(
                        color: ![7, 14, 30].contains(_timeRange)
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
                decoration: const BoxDecoration(
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
          title: const Text(LocaleKeys.general_time_range_dialog_title).tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _customTimeRangeFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText:
                        LocaleKeys.general_time_range_dialog_hint_text.tr(),
                  ),
                  validator: (value) {
                    if (!isNumeric(value)) {
                      return LocaleKeys
                          .general_time_range_dialog_validator_integer;
                    } else if (int.tryParse(value) < 2) {
                      return LocaleKeys
                          .general_time_range_dialog_validator_larger_1;
                    }

                    setState(() {
                      _timeRange = int.parse(value);
                    });

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                LocaleKeys.general_time_range_dialog_notice,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ).tr(),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(LocaleKeys.button_close).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(LocaleKeys.button_save).tr(),
              onPressed: () {
                if (_customTimeRangeFormKey.currentState.validate()) {
                  _mediaTypeGraphsBloc.add(
                    MediaTypeGraphsFetch(
                      tautulliId: _tautulliId,
                      timeRange: _timeRange,
                      yAxis: _yAxis,
                      settingsBloc: _settingsBloc,
                    ),
                  );
                  _streamTypeGraphsBloc.add(
                    StreamTypeGraphsFetch(
                      tautulliId: _tautulliId,
                      timeRange: _timeRange,
                      yAxis: _yAxis,
                      settingsBloc: _settingsBloc,
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
}
