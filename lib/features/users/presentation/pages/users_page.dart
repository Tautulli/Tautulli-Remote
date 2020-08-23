import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/users_bloc.dart';
import '../widgets/user_card.dart';
import '../widgets/user_error_button.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key key}) : super(key: key);

  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersBloc>(
      create: (context) => di.sl<UsersBloc>(),
      child: UsersPageContent(),
    );
  }
}

class UsersPageContent extends StatefulWidget {
  const UsersPageContent({Key key}) : super(key: key);

  @override
  _UsersPageContentState createState() => _UsersPageContentState();
}

class _UsersPageContentState extends State<UsersPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 500.0;
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  UsersBloc _usersBloc;
  String _tautulliId;
  String _orderColumn = 'friendly_name';
  String _orderDir = 'asc';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _usersBloc = context.bloc<UsersBloc>();

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
      } else {
        setState(() {
          _tautulliId = state.serverList[0].tautulliId;
        });
      }

      _usersBloc.add(
        UsersFetch(
          tautulliId: _tautulliId,
          orderColumn: _orderColumn,
          orderDir: _orderDir,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          PopupMenuButton(
            icon: _currentSortIcon(_orderColumn, _orderDir),
            tooltip: 'Sort users',
            onSelected: (value) {
              List<String> values = value.split('|');

              setState(() {
                _orderColumn = values[0];
                _orderDir = values[1];
              });
              _usersBloc.add(
                UsersFilter(
                  tautulliId: _tautulliId,
                  orderColumn: _orderColumn,
                  orderDir: _orderDir,
                ),
              );
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      _orderColumn == 'friendly_name' && _orderDir == 'asc'
                          ? FaIcon(FontAwesomeIcons.sortAlphaUp)
                          : FaIcon(FontAwesomeIcons.sortAlphaDown),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text('Name'),
                      ),
                    ],
                  ),
                  value: _orderColumn == 'friendly_name' && _orderDir == 'asc'
                      ? 'friendly_name|desc'
                      : 'friendly_name|asc',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      _orderColumn == 'last_seen' && _orderDir == 'desc'
                          ? FaIcon(FontAwesomeIcons.sortNumericUp)
                          : FaIcon(FontAwesomeIcons.sortNumericDown),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text('Last Streamed'),
                      ),
                    ],
                  ),
                  value: _orderColumn == 'last_seen' && _orderDir == 'desc'
                      ? 'last_seen|asc'
                      : 'last_seen|desc',
                ),
              ];
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
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
                                child:
                                    ServerHeader(serverName: server.plexName),
                                value: server.tautulliId,
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != _tautulliId) {
                                setState(() {
                                  _tautulliId = value;
                                  _settingsBloc.add(
                                    SettingsUpdateLastSelectedServer(
                                        tautulliId: _tautulliId),
                                  );
                                  _usersBloc.add(
                                    UsersFilter(
                                      tautulliId: _tautulliId,
                                      orderColumn: _orderColumn,
                                      orderDir: _orderDir,
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        );
                      }
                    }
                    return Container(height: 0, width: 0);
                  },
                ),
                BlocConsumer<UsersBloc, UsersState>(
                  listener: (context, state) {
                    if (state is UsersSuccess) {
                      _refreshCompleter?.complete();
                      _refreshCompleter = Completer();
                    }
                  },
                  builder: (context, state) {
                    if (state is UsersSuccess) {
                      if (state.list.length > 0) {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () {
                              _usersBloc.add(
                                UsersFilter(
                                  tautulliId: _tautulliId,
                                  orderColumn: _orderColumn,
                                  orderDir: _orderDir,
                                ),
                              );
                              return _refreshCompleter.future;
                            },
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: state.hasReachedMax
                                    ? state.list.length
                                    : state.list.length + 1,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  return index >= state.list.length
                                      ? BottomLoader()
                                      : UsersCard(user: state.list[index]);
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No users found.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    if (state is UsersFailure) {
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
                            UserErrorButton(
                              completer: _refreshCompleter,
                              failure: state.failure,
                              usersEvent: UsersFilter(
                                tautulliId: _tautulliId,
                                orderColumn: _orderColumn,
                                orderDir: _orderDir,
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
      _usersBloc.add(
        UsersFetch(
          tautulliId: _tautulliId,
          orderColumn: _orderColumn,
          orderDir: _orderDir,
        ),
      );
    }
  }

  FaIcon _currentSortIcon(
    String orderColumn,
    String orderDir,
  ) {
    if (orderColumn == 'friendly_name') {
      if (orderDir == 'asc') {
        return FaIcon(FontAwesomeIcons.sortAlphaDown);
      } else {
        return FaIcon(FontAwesomeIcons.sortAlphaUp);
      }
    }
    if (orderColumn == 'last_seen') {
      if (orderDir == 'asc') {
        return FaIcon(FontAwesomeIcons.sortNumericUp);
      } else {
        return FaIcon(FontAwesomeIcons.sortNumericDown);
      }
    }
  }
}
