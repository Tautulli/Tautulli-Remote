import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/synced_items_bloc.dart';
import '../widgets/synced_items_details.dart';
import '../widgets/synced_items_error_button.dart';

class SyncedItemsPage extends StatelessWidget {
  const SyncedItemsPage({Key key}) : super(key: key);

  static const routeName = '/synced';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncedItemsBloc>(
      create: (context) => di.sl<SyncedItemsBloc>(),
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
  String _tautulliId;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _syncedItemsBloc = context.bloc<SyncedItemsBloc>();
    final settingState = _settingsBloc.state;

    if (settingState is SettingsLoadSuccess) {
      String lastSelectedServer;

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
        _tautulliId = null;
      }

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
                                  _syncedItemsBloc.add(
                                    SyncedItemsFilter(
                                      tautulliId: _tautulliId,
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
                                  return PosterCard(
                                    item: state.list[index],
                                    details: SyncedItemsDetails(
                                      syncedItem: state.list[index],
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
                      child: Column(
                        children: [
                          Expanded(
                            child: const SizedBox(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    const SizedBox(height: 15),
                                    Text(
                                      'This may take longer for a large number of items',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                      // maxLines: 2,
                                      // softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: const SizedBox(),
                          ),
                        ],
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
}