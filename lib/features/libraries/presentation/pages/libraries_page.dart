import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/libraries_bloc.dart';
import '../widgets/library_card.dart';
import '../widgets/library_card_details.dart';

class LibrariesPage extends StatelessWidget {
  const LibrariesPage({super.key});

  static const routeName = '/libraries';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibrariesBloc>(),
      child: const LibrariesView(),
    );
  }
}

class LibrariesView extends StatefulWidget {
  const LibrariesView({super.key});

  @override
  State<LibrariesView> createState() => _LibrariesViewState();
}

class _LibrariesViewState extends State<LibrariesView> {
  final _scrollController = ScrollController();
  late LibrariesBloc _librariesBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;
  late String _orderColumn;
  late String _orderDir;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _librariesBloc = context.read<LibrariesBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    final librariesSort = settingsState.appSettings.librariesSort.split('|');
    _orderColumn = librariesSort[0];
    _orderDir = librariesSort[1];

    _librariesBloc.add(
      LibrariesFetched(
        server: _server,
        orderColumn: _orderColumn,
        orderDir: _orderDir,
        settingsBloc: _settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      // Listen for active server change and run a fresh user fetch if it does
      listenWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer != current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;

          _librariesBloc.add(
            LibrariesFetched(
              server: _server,
              orderColumn: _orderColumn,
              orderDir: _orderDir,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.libraries_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<LibrariesBloc, LibrariesState>(
          builder: (context, state) {
            return PageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: ThemedRefreshIndicator(
                onRefresh: () {
                  _librariesBloc.add(
                    LibrariesFetched(
                      server: _server,
                      orderColumn: _orderColumn,
                      orderDir: _orderDir,
                      freshFetch: true,
                      settingsBloc: _settingsBloc,
                    ),
                  );

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (state.libraries.isEmpty) {
                      if (state.status == BlocStatus.failure) {
                        return StatusPage(
                          scrollable: true,
                          message: state.message ?? '',
                          suggestion: state.suggestion ?? '',
                        );
                      }
                      if (state.status == BlocStatus.success) {
                        return const StatusPage(
                          scrollable: true,
                          message: 'No libraries',
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial ? state.libraries.length : state.libraries.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.libraries.length) {
                          return BottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              _librariesBloc.add(
                                LibrariesFetched(
                                  server: _server,
                                  orderColumn: _orderColumn,
                                  orderDir: _orderDir,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        final library = state.libraries[index];

                        return LibraryCard(
                          library: library,
                          details: LibraryCardDetails(library: library),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _librariesBloc.add(
        LibrariesFetched(
          server: _server,
          orderColumn: _orderColumn,
          orderDir: _orderDir,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: _currentSortIcon(),
        tooltip: 'Sort libraries',
        onSelected: (value) {
          if (value != null) {
            value as String;
            List<String> values = value.split('|');

            setState(() {
              _orderColumn = values[0];
              _orderDir = values[1];
            });

            _settingsBloc.add(SettingsUpdateLibrariesSort(value));
            _librariesBloc.add(
              LibrariesFetched(
                server: _server,
                orderColumn: _orderColumn,
                orderDir: _orderDir,
                freshFetch: true,
                settingsBloc: _settingsBloc,
              ),
            );
          }
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        itemBuilder: (context) {
          return <PopupMenuEntry<dynamic>>[
            PopupMenuItem(
              child: Row(
                children: [
                  _currentSortIcon(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      _currentSortName(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: _orderColumn == 'section_name' && _orderDir == 'asc' ? 'section_name|desc' : 'section_name|asc',
              child: Row(
                children: [
                  _orderColumn == 'section_name' && _orderDir == 'asc'
                      ? FaIcon(
                          FontAwesomeIcons.arrowDownZA,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : FaIcon(
                          FontAwesomeIcons.arrowDownAZ,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const Text(LocaleKeys.name_title).tr(),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: _orderColumn == 'count' && _orderDir == 'desc' ? 'count|asc' : 'count|desc',
              child: Row(
                children: [
                  _orderColumn == 'count' && _orderDir == 'desc'
                      ? FaIcon(
                          FontAwesomeIcons.arrowDown19,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : FaIcon(
                          FontAwesomeIcons.arrowDown91,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Count'),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: _orderColumn == 'duration' && _orderDir == 'desc' ? 'duration|asc' : 'duration|desc',
              child: Row(
                children: [
                  _orderColumn == 'duration' && _orderDir == 'desc'
                      ? FaIcon(
                          FontAwesomeIcons.arrowDown19,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : FaIcon(
                          FontAwesomeIcons.arrowDown91,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Time'),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: _orderColumn == 'plays' && _orderDir == 'desc' ? 'plays|asc' : 'plays|desc',
              child: Row(
                children: [
                  _orderColumn == 'plays' && _orderDir == 'desc'
                      ? FaIcon(
                          FontAwesomeIcons.arrowDown19,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : FaIcon(
                          FontAwesomeIcons.arrowDown91,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Plays'),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    ];
  }

  FaIcon _currentSortIcon({Color? color}) {
    color ??= Theme.of(context).colorScheme.onSurface;

    if (_orderColumn == 'section_name') {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.arrowDownAZ,
          size: 20,
          color: color,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.arrowDownZA,
          size: 20,
          color: color,
        );
      }
    } else {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.arrowDown19,
          size: 20,
          color: color,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.arrowDown91,
          size: 20,
          color: color,
        );
      }
    }
  }

  String _currentSortName() {
    switch (_orderColumn) {
      case ('section_name'):
        return LocaleKeys.name_title.tr();
      case ('count'):
        return 'Count';
      case ('duration'):
        return 'Time';
      case ('plays'):
        return 'Plays';
      default:
        return 'Unknown';
    }
  }
}
