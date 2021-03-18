import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/presentation/bloc/users_list_bloc.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_details.dart';
import '../widgets/history_error_button.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryBloc>(
          create: (_) => di.sl<HistoryBloc>(),
        ),
        BlocProvider<UsersListBloc>(
          create: (_) => di.sl<UsersListBloc>(),
        ),
      ],
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
  final _scrollThreshold = 200.0;
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  HistoryBloc _historyBloc;
  UsersListBloc _usersListBloc;
  String _tautulliId;
  int _userId;
  String _mediaType;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _historyBloc = context.read<HistoryBloc>();
    _usersListBloc = context.read<UsersListBloc>();

    final historyState = _historyBloc.state;
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
        setState(() {
          _tautulliId = null;
        });
      }

      if (historyState is HistoryInitial) {
        if (historyState.tautulliId == _tautulliId) {
          _userId = historyState.userId;
        } else {
          _userId = null;
        }
        _mediaType = historyState.mediaType ?? 'all';
      }

      _usersListBloc.add(
        UsersListFetch(
          tautulliId: _tautulliId,
          settingsBloc: _settingsBloc,
        ),
      );

      _historyBloc.add(
        HistoryFetch(
          tautulliId: _tautulliId,
          userId: _userId,
          mediaType: _mediaType,
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
        title: Text('History'),
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
                              _userId = null;
                            });
                            _settingsBloc.add(
                              SettingsUpdateLastSelectedServer(
                                tautulliId: _tautulliId,
                              ),
                            );
                            _historyBloc.add(
                              HistoryFilter(
                                tautulliId: value,
                                mediaType: _mediaType,
                              ),
                            );
                            _usersListBloc.add(
                              UsersListFetch(
                                tautulliId: _tautulliId,
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
            BlocConsumer<HistoryBloc, HistoryState>(
              listener: (context, state) {
                if (state is HistorySuccess) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is HistorySuccess) {
                  final SettingsLoadSuccess settingsState = _settingsBloc.state;

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
                                        server:
                                            settingsState.serverList.firstWhere(
                                          (server) =>
                                              server.tautulliId == _tautulliId,
                                        ),
                                        maskSensitiveInfo: _maskSensitiveInfo,
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
                          'No history ${_mediaTypeToTitle(_mediaType)}found.',
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
                          HistoryErrorButton(
                            completer: _refreshCompleter,
                            failure: state.failure,
                            historyEvent: HistoryFilter(
                              tautulliId: _tautulliId,
                              userId: _userId,
                              mediaType: _mediaType,
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
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  List<Widget> _appBarActions() {
    return [
      //* Users dropdown
      BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          if (state is UsersListSuccess) {
            return PopupMenuButton(
              tooltip: 'Users',
              icon: FaIcon(
                FontAwesomeIcons.userAlt,
                size: 20,
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
                          _maskSensitiveInfo
                              ? '*Hidden User*'
                              : user.friendlyName,
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
          if (state is UsersListInProgress) {
            return Center(
              child: Stack(
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.userAlt,
                      size: 20,
                    ),
                    color: Theme.of(context).disabledColor,
                    onPressed: () {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlexColorPalette.shark,
                          content: Text('Loading users'),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 5,
                    top: 25,
                    child: SizedBox(
                      height: 13,
                      width: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return IconButton(
            icon: FaIcon(FontAwesomeIcons.userAlt),
            color: Theme.of(context).disabledColor,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: PlexColorPalette.shark,
                  content: Text('Users failed to load'),
                ),
              );
            },
          );
        },
      ),
      //* Filter dropdown
      PopupMenuButton(
        icon: FaIcon(
          FontAwesomeIcons.filter,
          size: 20,
          color: _mediaType != 'all'
              ? Theme.of(context).accentColor
              : TautulliColorPalette.not_white,
        ),
        tooltip: 'Filter media type',
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

String _mediaTypeToTitle(String mediaType) {
  switch (mediaType) {
    case ('movie'):
      return 'for Movies ';
    case ('episode'):
      return 'for TV Shows ';
    case ('track'):
      return 'for Music ';
    case ('other_video'):
      return 'for Videos ';
    case ('live'):
      return 'for Live TV ';
    default:
      return '';
  }
}
