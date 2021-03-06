import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../bloc/libraries_bloc.dart';
import '../widgets/libraries_error_button.dart';
import '../widgets/library_details.dart';
import 'library_details_page.dart';

class LibrariesPage extends StatelessWidget {
  const LibrariesPage({Key key}) : super(key: key);

  static const routeName = '/libraries';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibrariesBloc>(),
      child: const LibrariesPageContent(),
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
    _settingsBloc = context.read<SettingsBloc>();
    _librariesBloc = context.read<LibrariesBloc>();

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
      } else if (settingsState.serverList.isNotEmpty) {
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
        leading: const AppDrawerIcon(),
        title: Text(
          LocaleKeys.libraries_page_title.tr(),
        ),
        actions: _appBarActions(),
      ),
      drawer: const AppDrawer(),
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
                  if (state.librariesList.isNotEmpty) {
                    return Expanded(
                      child: RefreshIndicator(
                        color: Theme.of(context).accentColor,
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
                              final heroTag = UniqueKey();

                              Library library = state.librariesList[index];
                              return GestureDetector(
                                onTap: () {
                                  if (library.sectionType != 'live') {
                                    return Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LibraryDetailsPage(
                                          library: library,
                                          sectionType: library.sectionType,
                                          heroTag: heroTag,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: IconCard(
                                  localIconImagePath:
                                      AssetMapperHelper.mapLibraryToPath(
                                          library.sectionType),
                                  iconImageUrl: library.iconUrl,
                                  iconColor: TautulliColorPalette.not_white,
                                  backgroundImage: library.sectionType != 'live'
                                      ? Image.network(
                                          library.backgroundUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/livetv_fallback.png',
                                          fit: BoxFit.cover,
                                        ),
                                  details: LibraryDetails(library: library),
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
                        child: const Text(
                          LocaleKeys.libraries_empty,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ).tr(),
                      ),
                    );
                  }
                }
                if (state is LibrariesFailure) {
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
                          LibrariesErrorButton(
                            completer: _refreshCompleter,
                            failure: state.failure,
                            librariesEvent: LibrariesFilter(
                              tautulliId: _tautulliId,
                              orderColumn: _orderColumn,
                              orderDir: _orderDir,
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
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: _currentSortIcon(),
        tooltip: LocaleKeys.general_tooltip_sort_libraries.tr(),
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
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      _currentSortName(),
                      style: const TextStyle(color: PlexColorPalette.gamboge),
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: Row(
                children: [
                  _orderColumn == 'section_name' && _orderDir == 'asc'
                      ? const FaIcon(
                          FontAwesomeIcons.sortAlphaDownAlt,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.sortAlphaDown,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const Text(LocaleKeys.general_filter_name).tr(),
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
                      ? const FaIcon(
                          FontAwesomeIcons.sortNumericDown,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.sortNumericDownAlt,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const Text(LocaleKeys.general_filter_count).tr(),
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
                      ? const FaIcon(
                          FontAwesomeIcons.sortNumericDown,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.sortNumericDownAlt,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const Text(LocaleKeys.general_filter_duration).tr(),
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
                      ? const FaIcon(
                          FontAwesomeIcons.sortNumericDown,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.sortNumericDownAlt,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const Text(LocaleKeys.general_filter_plays).tr(),
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
    if (_orderColumn == 'section_name') {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.sortAlphaDown,
          size: 20,
          color: color ?? TautulliColorPalette.not_white,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.sortAlphaDownAlt,
          size: 20,
          color: color ?? TautulliColorPalette.not_white,
        );
      }
    } else {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.sortNumericDown,
          size: 20,
          color: color ?? TautulliColorPalette.not_white,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.sortNumericDownAlt,
          size: 20,
          color: color ?? TautulliColorPalette.not_white,
        );
      }
    }
  }

  String _currentSortName() {
    switch (_orderColumn) {
      case ('section_name'):
        return LocaleKeys.general_filter_name.tr();
      case ('count,parent_count,child_count'):
        return LocaleKeys.general_filter_count.tr();
      case ('duration'):
        return LocaleKeys.general_filter_duration.tr();
      case ('plays'):
        return LocaleKeys.general_filter_name.tr();
      default:
        return LocaleKeys.media_details_unknown.tr();
    }
  }
}
