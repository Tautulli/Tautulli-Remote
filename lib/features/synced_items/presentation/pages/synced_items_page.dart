import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/presentation/bloc/users_list_bloc.dart';
import '../bloc/synced_items_bloc.dart';
import '../widgets/synced_items_details.dart';
import '../widgets/synced_items_error_button.dart';

class SyncedItemsPage extends StatelessWidget {
  const SyncedItemsPage({Key key}) : super(key: key);

  static const routeName = '/synced';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SyncedItemsBloc>(
          create: (_) => di.sl<SyncedItemsBloc>(),
        ),
        BlocProvider<UsersListBloc>(
          create: (_) => di.sl<UsersListBloc>(),
        ),
      ],
      child: SyncedItemsPageContent(),
    );
  }
}

class SyncedItemsPageContent extends StatefulWidget {
  SyncedItemsPageContent({Key key}) : super(key: key);

  @override
  _SyncedItemsPageContentState createState() => _SyncedItemsPageContentState();
}

class _SyncedItemsPageContentState extends State<SyncedItemsPageContent> {
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  SyncedItemsBloc _syncedItemsBloc;
  UsersListBloc _usersListBloc;
  String _tautulliId;
  int _userId;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _syncedItemsBloc = context.read<SyncedItemsBloc>();
    _usersListBloc = context.read<UsersListBloc>();

    final syncedItemsState = _syncedItemsBloc.state;
    final settingState = _settingsBloc.state;

    if (settingState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingState.maskSensitiveInfo;

      if (settingState.lastSelectedServer != null) {
        for (Server server in settingState.serverList) {
          if (server.tautulliId == settingState.lastSelectedServer) {
            lastSelectedServer = settingState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingState.serverList[0].tautulliId;
        });
      } else {
        setState(() {
          _tautulliId = null;
        });
      }

      if (syncedItemsState is SyncedItemsInitial) {
        if (syncedItemsState.tautulliId == _tautulliId) {
          _userId = syncedItemsState.userId;
        } else {
          _userId = null;
        }
      }

      _usersListBloc.add(
        UsersListFetch(
          tautulliId: _tautulliId,
        ),
      );

      _syncedItemsBloc.add(
        SyncedItemsFetch(
          tautulliId: _tautulliId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Synced Items'),
        actions: _appBarActions(),
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
                                  _userId = null;
                                });
                                _settingsBloc.add(
                                  SettingsUpdateLastSelectedServer(
                                    tautulliId: _tautulliId,
                                  ),
                                );
                                _syncedItemsBloc.add(
                                  SyncedItemsFilter(
                                    tautulliId: _tautulliId,
                                  ),
                                );
                                _usersListBloc.add(
                                  UsersListFetch(
                                    tautulliId: _tautulliId,
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
                BlocConsumer<SyncedItemsBloc, SyncedItemsState>(
                  listener: (context, state) {
                    if (state is SyncedItemsSuccess) {
                      _refreshCompleter?.complete();
                      _refreshCompleter = Completer();
                    }
                  },
                  builder: (context, state) {
                    if (state is SyncedItemsSuccess) {
                      if (state.list.length > 0) {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () {
                              _syncedItemsBloc.add(
                                SyncedItemsFilter(
                                  tautulliId: _tautulliId,
                                ),
                              );
                              return _refreshCompleter.future;
                            },
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: state.list.length,
                                itemBuilder: (context, index) {
                                  final heroTag = UniqueKey();

                                  return GestureDetector(
                                    onTap: () {
                                      final syncedItem = state.list[index];

                                      MediaItem mediaItem = MediaItem(
                                        posterUrl: syncedItem.posterUrl,
                                        ratingKey: syncedItem.ratingKey,
                                      );

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MediaItemPage(
                                            item: mediaItem,
                                            heroTag: heroTag,
                                            forceChildrenMetadataFetch: true,
                                            enableNavOptions: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: PosterCard(
                                      item: state.list[index],
                                      details: SyncedItemsDetails(
                                        syncedItem: state.list[index],
                                        maskSensitiveInfo: _maskSensitiveInfo,
                                      ),
                                      heroTag: heroTag,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No synced items found.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    if (state is SyncedItemsFailure) {
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
                            SyncedItemsErrorButton(
                              completer: _refreshCompleter,
                              failure: state.failure,
                              syncedItemsEvent: SyncedItemsFilter(
                                tautulliId: _tautulliId,
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
                )
              ],
            ),
          );
        },
      ),
    );
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
                  _syncedItemsBloc.add(
                    SyncedItemsFilter(
                      tautulliId: _tautulliId,
                      userId: _userId,
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
    ];
  }
}
