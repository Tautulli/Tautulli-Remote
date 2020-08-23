import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_details.dart';
import '../widgets/history_error_button.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HistoryBloc>(),
      child: HistoryPageContent(),
    );
  }
}

class HistoryPageContent extends StatefulWidget {
  const HistoryPageContent({Key key}) : super(key: key);

  @override
  _HistoryPageContentState createState() => _HistoryPageContentState();
}

class _HistoryPageContentState extends State<HistoryPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 500.0;
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  HistoryBloc _historyBloc;
  String _tautulliId;
  int _userId;
  String _mediaType = 'all';
  bool _historyLoaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _historyBloc = context.bloc<HistoryBloc>();

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
        setState(() {
          _tautulliId = null;
        });
      }

      _historyBloc.add(
        HistoryFetch(
          tautulliId: _tautulliId,
          userId: _userId,
          mediaType: _mediaType,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('History'),
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
                            _userId = null;
                            _mediaType = 'all';
                          });
                          _settingsBloc.add(
                            SettingsUpdateLastSelectedServer(
                                tautulliId: _tautulliId),
                          );
                          _historyBloc.add(
                            HistoryFilter(tautulliId: value),
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
          BlocConsumer<HistoryBloc, HistoryState>(
            listener: (context, state) {
              if (state is HistorySuccess) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is HistorySuccess) {
                if (state.list.length > 0) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        _historyBloc.add(
                          HistoryFilter(
                            tautulliId: _tautulliId,
                            userId: _userId,
                            mediaType: _mediaType,
                          ),
                        );
                        return _refreshCompleter.future;
                      },
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return index >= state.list.length
                                ? BottomLoader()
                                : PosterCard(
                                    item: state.list[index],
                                    details: HistoryDetails(
                                      historyItem: state.list[index],
                                    ),
                                  );
                          },
                          itemCount: state.hasReachedMax
                              ? state.list.length
                              : state.list.length + 1,
                          controller: _scrollController,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No history found.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }
              }
              if (state is HistoryFailure) {
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
                      HistoryErrorButton(
                        completer: _refreshCompleter,
                        failure: state.failure,
                        historyEvent: HistoryFilter(
                          tautulliId: _tautulliId,
                          userId: _userId,
                          mediaType: _mediaType,
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _historyBloc.add(
        HistoryFetch(
          tautulliId: _tautulliId,
          userId: _userId,
          mediaType: _mediaType,
        ),
      );
    }
  }

  List<Widget> _appBarActions() {
    return [
      BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistorySuccess) {
            setState(() {
              _historyLoaded = true;
            });
          } else {
            setState(() {
              _historyLoaded = false;
            });
          }
        },
        builder: (context, state) {
          if (state is HistorySuccess) {
            return PopupMenuButton(
              tooltip: 'Users',
              icon: FaIcon(
                FontAwesomeIcons.userAlt,
                color: _userId != null
                    ? Theme.of(context).accentColor
                    : TautulliColorPalette.not_white,
              ),
              onSelected: (value) {
                setState(() {
                  if (value == -1) {
                    _userId = null;
                  } else {
                    _userId = value;
                  }
                  _historyBloc.add(
                    HistoryFilter(
                      tautulliId: _tautulliId,
                      userId: _userId,
                      mediaType: _mediaType,
                    ),
                  );
                });
              },
              itemBuilder: (context) {
                return state.usersList
                    .map(
                      (user) => PopupMenuItem(
                        child: Text(
                          user.friendlyName,
                          style: TextStyle(
                            color: _userId == user.userId
                                ? Theme.of(context).accentColor
                                : TautulliColorPalette.not_white,
                          ),
                        ),
                        value: user.userId,
                      ),
                    )
                    .toList();
              },
            );
          }
          return IconButton(
            icon: FaIcon(FontAwesomeIcons.userAlt),
            onPressed: null,
          );
        },
      ),
      PopupMenuButton(
        icon: FaIcon(FontAwesomeIcons.filter),
        tooltip: 'Filter media type',
        enabled: _historyLoaded,
        onSelected: (value) {
          if (_mediaType != value) {
            setState(() {
              _mediaType = value;
            });
            _historyBloc.add(
              HistoryFilter(
                tautulliId: _tautulliId,
                userId: _userId,
                mediaType: _mediaType,
              ),
            );
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text(
                'All',
                style: TextStyle(
                  color: _mediaType == 'all'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ),
              value: 'all',
            ),
            PopupMenuItem(
              child: Text(
                'Movies',
                style: TextStyle(
                  color: _mediaType == 'movie'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ),
              value: 'movie',
            ),
            PopupMenuItem(
              child: Text(
                'TV Shows',
                style: TextStyle(
                  color: _mediaType == 'episode'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ),
              value: 'episode',
            ),
            PopupMenuItem(
              child: Text(
                'Music',
                style: TextStyle(
                  color: _mediaType == 'track'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ),
              value: 'track',
            ),
            PopupMenuItem(
              child: Text(
                'Live TV',
                style: TextStyle(
                  color: _mediaType == 'live'
                      ? Theme.of(context).accentColor
                      : TautulliColorPalette.not_white,
                ),
              ),
              value: 'live',
            ),
          ];
        },
      ),
    ];
  }
}
