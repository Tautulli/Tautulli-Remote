// @dart=2.9

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/inherited_headers.dart';
import '../../../../core/widgets/inner_drawer_scaffold.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
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
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _syncedItemsBloc = context.read<SyncedItemsBloc>();
    _usersListBloc = context.read<UsersListBloc>();

    final syncedItemsState = _syncedItemsBloc.state;
    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingsState.maskSensitiveInfo;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;

            for (CustomHeaderModel header in server.customHeaders) {
              headerMap[header.key] = header.value;
            }

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
          for (CustomHeaderModel header
              in settingsState.serverList[0].customHeaders) {
            headerMap[header.key] = header.value;
          }
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
          settingsBloc: _settingsBloc,
        ),
      );

      _syncedItemsBloc.add(
        SyncedItemsFetch(
          tautulliId: _tautulliId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final SettingsLoadSuccess settingsLoadSuccess = settingsBloc.state;

    return InnerDrawerScaffold(
      title: Text(
        LocaleKeys.synced_items_page_title.tr(),
      ),
      actions: _appBarActions(),
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
                                final server = state.serverList.firstWhere(
                                    (server) => server.tautulliId == value);
                                Map<String, String> newHeaderMap = {};
                                for (CustomHeaderModel header
                                    in server.customHeaders) {
                                  newHeaderMap[header.key] = header.value;
                                }

                                setState(() {
                                  _tautulliId = value;
                                  _userId = null;
                                  headerMap = newHeaderMap;
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
                      if (state.list.isNotEmpty) {
                        return InheritedHeaders(
                          headerMap: headerMap,
                          child: Expanded(
                            child: RefreshIndicator(
                              color: Theme.of(context).accentColor,
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
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  PlexColorPalette.shark,
                                              content: const Text(
                                                LocaleKeys
                                                    .synced_items_media_details_unsupported,
                                              ).tr(),
                                              action: SnackBarAction(
                                                label: LocaleKeys
                                                    .button_learn_more
                                                    .tr(),
                                                onPressed: () async {
                                                  await launch(
                                                    'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#synced_items_caveats',
                                                  );
                                                },
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
                                              builder: (context) =>
                                                  MediaItemPage(
                                                item: mediaItem,
                                                syncedMediaType:
                                                    syncedItem.syncMediaType ??
                                                        syncedItem.mediaType,
                                                heroTag: heroTag,
                                                forceChildrenMetadataFetch:
                                                    true,
                                                enableNavOptions: true,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Slidable.builder(
                                            key: ValueKey(
                                              '$_tautulliId:${syncedItem.syncId}',
                                            ),
                                            controller: _slidableController,
                                            actionPane:
                                                const SlidableBehindActionPane(),
                                            secondaryActionDelegate:
                                                SlideActionBuilderDelegate(
                                              actionCount: 1,
                                              builder: (context, index,
                                                  animation, step) {
                                                return _SlidableAction(
                                                  tautulliId: _tautulliId,
                                                  slidableState:
                                                      Slidable.of(context),
                                                  syncedItem: syncedItem,
                                                  maskSensitiveInfo:
                                                      settingsLoadSuccess
                                                          .maskSensitiveInfo,
                                                  settingsBloc: _settingsBloc,
                                                );
                                              },
                                            ),
                                            child: ClipRRect(
                                              child: PosterCard(
                                                cardMargin:
                                                    const EdgeInsets.all(0),
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
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Center(
                            child: const Text(
                              LocaleKeys.synced_items_empty,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ).tr(),
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
                        child: CircularProgressIndicator(
                          color: Theme.of(context).accentColor,
                        ),
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
              tooltip: LocaleKeys.general_filter_users.tr(),
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
                              ? '*${LocaleKeys.masked_info_user.tr()}*'
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
                    icon: const FaIcon(
                      FontAwesomeIcons.userAlt,
                      size: 20,
                    ),
                    color: Theme.of(context).disabledColor,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlexColorPalette.shark,
                          content: const Text(
                            LocaleKeys.general_filter_users_loading,
                          ).tr(),
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
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return IconButton(
            icon: const FaIcon(FontAwesomeIcons.userAlt),
            color: Theme.of(context).disabledColor,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: PlexColorPalette.shark,
                  content: const Text(
                    LocaleKeys.general_filter_users_failed,
                  ).tr(),
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
  final SettingsBloc settingsBloc;

  const _SlidableAction({
    @required this.tautulliId,
    @required this.slidableState,
    @required this.syncedItem,
    @required this.maskSensitiveInfo,
    @required this.settingsBloc,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteSyncedItemBloc, DeleteSyncedItemState>(
      listener: (context, state) {
        if (state is DeleteSyncedItemSuccess) {
          state.slidableState.close();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: const Text(
                LocaleKeys.synced_items_delete_request,
              ).tr(),
              action: SnackBarAction(
                label: LocaleKeys.button_learn_more.tr(),
                onPressed: () async {
                  await launch(
                    'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#synced_items_caveats',
                  );
                },
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
                    settingsBloc: settingsBloc,
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
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TautulliColorPalette.not_white,
                  ),
                ),
              );
            }
            return const DeleteSyncedItemButton();
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
        title: const Text(LocaleKeys.synced_items_delete_dialog_title).tr(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              syncedItem.syncTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PlexColorPalette.gamboge,
              ),
            ),
            Text(
              maskSensitiveInfo
                  ? '*${LocaleKeys.masked_info_user.tr()}*'
                  : syncedItem.user,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PlexColorPalette.gamboge,
              ),
            ),
            Text(
              syncedItem.deviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PlexColorPalette.gamboge,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              child: const Text(LocaleKeys.button_delete).tr(),
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
