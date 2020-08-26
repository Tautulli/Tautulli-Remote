import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/libraries_bloc.dart';
import '../widgets/libraries_error_button.dart';
import '../widgets/library_card.dart';

class LibrariesPage extends StatelessWidget {
  const LibrariesPage({Key key}) : super(key: key);

  static const routeName = '/libraries';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibrariesBloc>(),
      child: LibrariesPageContent(),
    );
  }
}

class LibrariesPageContent extends StatefulWidget {
  const LibrariesPageContent({Key key}) : super(key: key);

  @override
  _LibrariesPageContentState createState() => _LibrariesPageContentState();
}

class _LibrariesPageContentState extends State<LibrariesPageContent> {
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  LibrariesBloc _librariesBloc;
  String _tautulliId;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _librariesBloc = context.bloc<LibrariesBloc>();

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

      _librariesBloc.add(
        LibrariesFetch(
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
        title: Text('Libraries'),
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
                          _librariesBloc.add(
                            LibrariesFilter(tautulliId: value),
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
          BlocConsumer<LibrariesBloc, LibrariesState>(
            listener: (context, state) {
              if (state is LibrariesSuccess) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is LibrariesSuccess) {
                if (state.librariesCount > 0) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        _librariesBloc.add(
                          LibrariesFilter(tautulliId: _tautulliId),
                        );
                        return _refreshCompleter.future;
                      },
                      child: Scrollbar(
                        child: ListView(
                          children: [
                            if (state.librariesMap['movie'].length > 0)
                              LibraryCard(
                                list: state.librariesMap['movie'],
                                imageUrl: state.imageMap['movie'],
                                libraryType: LibraryType.movie,
                              ),
                            if (state.librariesMap['show'].length > 0)
                              LibraryCard(
                                list: state.librariesMap['show'],
                                imageUrl: state.imageMap['show'],
                                libraryType: LibraryType.show,
                              ),
                            if (state.librariesMap['artist'].length > 0)
                              LibraryCard(
                                list: state.librariesMap['artist'],
                                imageUrl: state.imageMap['artist'],
                                libraryType: LibraryType.artist,
                              ),
                            if (state.librariesMap['photo'].length > 0)
                              LibraryCard(
                                list: state.librariesMap['photo'],
                                imageUrl: state.imageMap['photo'],
                                libraryType: LibraryType.photo,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No libraries found.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }
              }
              if (state is LibrariesFailure) {
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
                      LibrariesErrorButton(
                        completer: _refreshCompleter,
                        failure: state.failure,
                        librariesEvent: LibrariesFilter(
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
          ),
        ],
      ),
    );
  }
}
