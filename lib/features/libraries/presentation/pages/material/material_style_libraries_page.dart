import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/material/material_style_bottom_loader.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_scaffold_with_inner_drawer.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/libraries_bloc.dart';
import '../../widgets/material/bottom_sheets/material_style_libraries_sort_bottom_sheet.dart';
import '../../widgets/material/material_style_library_card.dart';
import '../../widgets/base/library_card_details.dart';

class MaterialStyleLibrariesPage extends StatelessWidget {
  const MaterialStyleLibrariesPage({super.key});

  static const routeName = '/libraries';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibrariesBloc>(param1: context.read<SettingsBloc>()),
      child: const MaterialStyleLibrariesView(),
    );
  }
}

class MaterialStyleLibrariesView extends StatefulWidget {
  const MaterialStyleLibrariesView({super.key});

  @override
  State<MaterialStyleLibrariesView> createState() => _MaterialStyleLibrariesViewState();
}

class _MaterialStyleLibrariesViewState extends State<MaterialStyleLibrariesView> {
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
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
            ),
          );
        }
      },
      child: MaterialStyleScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.libraries_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<LibrariesBloc, LibrariesState>(
          builder: (context, state) {
            return MaterialStylePageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: MaterialStyleRefreshIndicator(
                onRefresh: () {
                  _librariesBloc.add(
                    LibrariesFetched(
                      server: _server,
                      orderColumn: _orderColumn,
                      orderDir: _orderDir,
                      freshFetch: true,
                    ),
                  );

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (state.libraries.isEmpty) {
                      if (state.status == BlocStatus.failure) {
                        return MaterialStyleStatusPage(
                          scrollable: true,
                          message: state.message ?? '',
                          suggestion: state.suggestion ?? '',
                        );
                      }
                      if (state.status == BlocStatus.success) {
                        return MaterialStyleStatusPage(
                          scrollable: true,
                          message: LocaleKeys.libraries_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? state.libraries.length
                          : state.libraries.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.libraries.length) {
                          return MaterialStyleBottomLoader(
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
                                ),
                              );
                            },
                          );
                        }

                        final library = state.libraries[index];

                        return MaterialStyleLibraryCard(
                          library: library,
                          details: LibraryCardDetails(
                            library: library,
                            textColor: Theme.of(context).colorScheme.onSurface,
                          ),
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
      IconButton(
        tooltip: LocaleKeys.sort_libraries_title.tr(),
        icon: FaIcon(
          FontAwesomeIcons.upDown,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<Map<String, String>>(
            context: context,
            isScrollControlled: true,
            builder: (_) => MaterialStyleLibrariesSortBottomSheet(
              orderColumn: _orderColumn,
              orderDir: _orderDir,
            ),
          );

          if (result != null && (result['orderColumn'] != _orderColumn || result['orderDir'] != _orderDir)) {
            setState(() {
              _orderColumn = result['orderColumn']!;
              _orderDir = result['orderDir']!;
            });

            _settingsBloc.add(SettingsUpdateLibrariesSort('$_orderColumn|$_orderDir'));
            _librariesBloc.add(
              LibrariesFetched(
                server: _server,
                orderColumn: _orderColumn,
                orderDir: _orderDir,
                freshFetch: true,
              ),
            );
          }
        },
      ),
    ];
  }
}
