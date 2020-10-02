import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote_tdd/core/helpers/color_palette_helper.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../bloc/libraries_bloc.dart';
import '../widgets/libraries_error_button.dart';
import '../widgets/library_details.dart';

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
  String _orderColumn;
  String _orderDir;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.bloc<SettingsBloc>();
    _librariesBloc = context.bloc<LibrariesBloc>();

    final librariesState = _librariesBloc.state;
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
      } else if (settingsState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        setState(() {
          _tautulliId = null;
        });
      }

      if (librariesState is LibrariesInitial) {
        _orderColumn = librariesState.orderColumn ?? 'section_name';
        _orderDir = librariesState.orderDir ?? 'asc';
      }

      _librariesBloc.add(
        LibrariesFetch(
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
        title: Text('Libraries'),
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
                          _librariesBloc.add(
                            LibrariesFilter(
                              tautulliId: value,
                              orderColumn: _orderColumn,
                              orderDir: _orderDir,
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
          BlocConsumer<LibrariesBloc, LibrariesState>(
            listener: (context, state) {
              if (state is LibrariesSuccess) {
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is LibrariesSuccess) {
                if (state.librariesList.length > 0) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        _librariesBloc.add(
                          LibrariesFilter(
                            tautulliId: _tautulliId,
                            orderColumn: _orderColumn,
                            orderDir: _orderDir,
                          ),
                        );
                        return _refreshCompleter.future;
                      },
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: state.librariesList.length,
                          itemBuilder: (context, index) {
                            Library library = state.librariesList[index];
                            return IconCard(
                              assetPath: AssetMapperHelper()
                                  .mapLibraryToPath(library.sectionType),
                              backgroundImage: library.sectionType != 'live'
                                  ? Image.network(
                                      state.imageMap[library.sectionId],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/livetv_fallback.png',
                                      fit: BoxFit.cover,
                                    ),
                              details: LibraryDetails(library: library),
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
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: _currentSortIcon(),
        tooltip: 'Sort libraries',
        onSelected: (value) {
          List<String> values = value.split('|');

          setState(() {
            _orderColumn = values[0];
            _orderDir = values[1];
          });
          _librariesBloc.add(
            LibrariesFilter(
              tautulliId: _tautulliId,
              orderColumn: _orderColumn,
              orderDir: _orderDir,
            ),
          );
        },
        itemBuilder: (context) {
          return <PopupMenuEntry<dynamic>>[
            PopupMenuItem(
              child: Row(
                children: [
                  _currentSortIcon(color: PlexColorPalette.gamboge),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      _currentSortName(),
                      style: TextStyle(color: PlexColorPalette.gamboge),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              child: Row(
                children: [
                  _orderColumn == 'section_name' && _orderDir == 'asc'
                      ? FaIcon(FontAwesomeIcons.sortAmountDown)
                      : FaIcon(FontAwesomeIcons.sortAmountDownAlt),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('Name'),
                  ),
                ],
              ),
              value: _orderColumn == 'section_name' && _orderDir == 'asc'
                  ? 'section_name|desc'
                  : 'section_name|asc',
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  _orderColumn == 'count,parent_count,child_count' &&
                          _orderDir == 'desc'
                      ? FaIcon(FontAwesomeIcons.sortAmountDownAlt)
                      : FaIcon(FontAwesomeIcons.sortAmountDown),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('Count'),
                  ),
                ],
              ),
              value: _orderColumn == 'count,parent_count,child_count' &&
                      _orderDir == 'desc'
                  ? 'count,parent_count,child_count|asc'
                  : 'count,parent_count,child_count|desc',
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  _orderColumn == 'duration' && _orderDir == 'desc'
                      ? FaIcon(FontAwesomeIcons.sortAmountDownAlt)
                      : FaIcon(FontAwesomeIcons.sortAmountDown),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('Duration'),
                  ),
                ],
              ),
              value: _orderColumn == 'duration' && _orderDir == 'desc'
                  ? 'duration|asc'
                  : 'duration|desc',
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  _orderColumn == 'plays' && _orderDir == 'desc'
                      ? FaIcon(FontAwesomeIcons.sortAmountDownAlt)
                      : FaIcon(FontAwesomeIcons.sortAmountDown),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('Plays'),
                  ),
                ],
              ),
              value: _orderColumn == 'plays' && _orderDir == 'desc'
                  ? 'plays|asc'
                  : 'plays|desc',
            ),
          ];
        },
      ),
    ];
  }

  FaIcon _currentSortIcon({Color color}) {
    if (_orderDir == 'asc') {
      return FaIcon(
        FontAwesomeIcons.sortAmountDownAlt,
        color: color ?? TautulliColorPalette.not_white,
      );
    } else {
      return FaIcon(
        FontAwesomeIcons.sortAmountDown,
        color: color ?? TautulliColorPalette.not_white,
      );
    }
  }

  String _currentSortName() {
    switch (_orderColumn) {
      case ('section_name'):
        return 'Name';
      case ('count,parent_count,child_count'):
        return 'Count';
      case ('duration'):
        return 'Duration';
      case ('plays'):
        return 'Plays';
    }
  }
}