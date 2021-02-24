import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/presentation/bloc/users_list_bloc.dart';
import '../../domain/entities/synced_item.dart';
import '../bloc/delete_synced_item_bloc.dart';
import '../bloc/synced_items_bloc.dart';
import '../widgets/delete_synced_item_button.dart';
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
        BlocProvider<DeleteSyncedItemBloc>(
          create: (_) => di.sl<DeleteSyncedItemBloc>(),
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
    final settingsBloc = context.read<SettingsBloc>();
    final SettingsLoadSuccess settingsLoadSuccess = settingsBloc.state;

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
                    final SlidableController _slidableController =
                        SlidableController();

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
                                  final syncedItem = state.list[index];
                                  final heroTag = UniqueKey();

                                  return GestureDetector(
                                    onTap: () {
                                      if (syncedItem.multipleRatingKeys) {
                                        Scaffold.of(context)
                                            .hideCurrentSnackBar();
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                PlexColorPalette.shark,
                                            content: Text(
                                                'Media details for this type of synced item is not supported.'),
                                            //TODO: Link action to help or wiki
                                            action: SnackBarAction(
                                              label: 'Learn more',
                                              onPressed: () {},
                                              textColor: TautulliColorPalette
                                                  .not_white,
                                            ),
                                          ),
                                        );
                                      } else {
                                        MediaItem mediaItem = MediaItem(
                                          posterUrl: syncedItem.posterUrl,
                                          ratingKey: syncedItem.ratingKey,
                                        );

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MediaItemPage(
                                              item: mediaItem,
                                              syncedMediaType:
                                                  syncedItem.syncMediaType ??
                                                      syncedItem.mediaType,
                                              heroTag: heroTag,
                                              forceChildrenMetadataFetch: true,
                                              enableNavOptions: true,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Slidable.builder(
                                          key: ValueKey(
                                            '$_tautulliId:${syncedItem.syncId}',
                                          ),
                                          controller: _slidableController,
                                          actionPane:
                                              SlidableBehindActionPane(),
                                          secondaryActionDelegate:
                                              SlideActionBuilderDelegate(
                                            actionCount: 1,
                                            builder: (context, index, animation,
                                                step) {
                                              return _SlidableAction(
                                                tautulliId: _tautulliId,
                                                slidableState:
                                                    Slidable.of(context),
                                                syncedItem: syncedItem,
                                                maskSensitiveInfo:
                                                    settingsLoadSuccess
                                                        .maskSensitiveInfo,
                                              );
                                            },
                                          ),
                                          child: ClipRRect(
                                            child: PosterCard(
                                              cardMargin: EdgeInsets.all(0),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              item: syncedItem,
                                              details: SyncedItemsDetails(
                                                syncedItem: syncedItem,
                                                maskSensitiveInfo:
                                                    _maskSensitiveInfo,
                                              ),
                                              heroTag: heroTag,
                                            ),
                                          ),
                                        ),
                                      ),
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
                              SyncedItemsErrorButton(
                                completer: _refreshCompleter,
                                failure: state.failure,
                                syncedItemsEvent: SyncedItemsFilter(
                                  tautulliId: _tautulliId,
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

class _SlidableAction extends StatelessWidget {
  final String tautulliId;
  final SlidableState slidableState;
  final SyncedItem syncedItem;
  final bool maskSensitiveInfo;

  const _SlidableAction({
    @required this.tautulliId,
    @required this.slidableState,
    @required this.syncedItem,
    @required this.maskSensitiveInfo,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteSyncedItemBloc, DeleteSyncedItemState>(
      listener: (context, state) {
        if (state is DeleteSyncedItemSuccess) {
          state.slidableState.close();
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Delete synced item request sent to Plex.'),
              //TODO: Link action to help or wiki
              action: SnackBarAction(
                label: 'Learn more',
                onPressed: () {},
                textColor: TautulliColorPalette.not_white,
              ),
            ),
          );
        }
        if (state is DeleteSyncedItemFailure) {
          showFailureAlertDialog(
            context: context,
            failure: state.failure,
          );
        }
      },
      child: SlideAction(
        closeOnTap: false,
        onTap: () async {
          final confirm = await _showDeleteSyncedItemDialog(
            context: context,
            syncedItem: syncedItem,
            maskSensitiveInfo: maskSensitiveInfo,
          );
          if (confirm == 1) {
            context.read<DeleteSyncedItemBloc>().add(
                  DeleteSyncedItemStarted(
                    tautulliId: tautulliId,
                    clientId: syncedItem.clientId,
                    syncId: syncedItem.syncId,
                    slidableState: slidableState,
                  ),
                );
          } else {
            Slidable.of(context).close();
          }
        },
        color: Theme.of(context).errorColor,
        child: BlocBuilder<DeleteSyncedItemBloc, DeleteSyncedItemState>(
          builder: (context, state) {
            if (state is DeleteSyncedItemInProgress &&
                state.syncId == syncedItem.syncId) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TautulliColorPalette.not_white,
                  ),
                ),
              );
            }
            return DeleteSyncedItemButton();
          },
        ),
      ),
    );
  }
}

Future<int> _showDeleteSyncedItemDialog({
  @required BuildContext context,
  @required SyncedItem syncedItem,
  @required bool maskSensitiveInfo,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you want to delete this synced item?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              syncedItem.syncTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PlexColorPalette.gamboge,
              ),
            ),
            Text(
              maskSensitiveInfo ? '*Hidden User*' : syncedItem.user,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PlexColorPalette.gamboge,
              ),
            ),
            Text(
              syncedItem.deviceName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PlexColorPalette.gamboge,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              child: Text('DELETE'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
          ),
        ],
      );
    },
  );
}
