import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../core/widgets/ios/ios_bottom_loader.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/libraries_bloc.dart';
import '../../widgets/cupertino/cupertino_style_libraries_filter_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_library_card.dart';
import '../../widgets/library_card_details.dart';

class CupertinoStyleLibrariesPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const CupertinoStyleLibrariesPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    this.refreshOnLoad = false,
  });

  static const routeName = '/libraries';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibrariesBloc>(),
      child: CupertinoStyleLibrariesView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
        refreshOnLoad: refreshOnLoad,
      ),
    );
  }
}

class CupertinoStyleLibrariesView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const CupertinoStyleLibrariesView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.refreshOnLoad,
  });

  @override
  State<CupertinoStyleLibrariesView> createState() => _CupertinoStyleLibrariesViewState();
}

class _CupertinoStyleLibrariesViewState extends State<CupertinoStyleLibrariesView> {
  final _scrollController = ScrollController();
  late LibrariesBloc _librariesBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;
  late String _orderColumn;
  late String _orderDir;
  late Completer<void> _refreshCompleter;
  bool _filterRefresh = true;

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

    _refreshCompleter = Completer<void>();

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

          _filterRefresh = true;

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
      child: PageScaffoldCupertino(
        showBackButton: widget.showBackButton,
        previousPageTitle: widget.previousPageTitle,
        showServerSelect: true,
        trailing: _navBarActions(),
        middle: const Text(LocaleKeys.libraries_title).tr(),
        child: BlocConsumer<LibrariesBloc, LibrariesState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              _filterRefresh = false;
            }
          },
          builder: (context, state) {
            if (state.libraries.isEmpty) {
              if (state.status == BlocStatus.failure) {
                return _statusWidget(
                  child: StatusIosPage(
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  ),
                );
              }
              if (state.status == BlocStatus.success) {
                return _statusWidget(
                  child: StatusIosPage(
                    message: LocaleKeys.recently_added_empty_message.tr(),
                  ),
                );
              }
            }

            if (_filterRefresh && [BlocStatus.initial, BlocStatus.inProgress].contains(state.status)) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return CupertinoScrollbar(
              controller: _scrollController,
              child: CupertinoRefreshPage(
                scrollController: _scrollController,
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

                  return _refreshCompleter.future;
                },
                sliver: SliverPadding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final itemIndex = index ~/ 2;

                        if (itemIndex >= state.libraries.length) {
                          return IosBottomLoader(
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

                        if (index.isEven) {
                          final library = state.libraries[itemIndex];

                          return CupertinoStyleLibraryCard(
                            library: library,
                            details: LibraryCardDetails(library: library),
                          );
                        } else {
                          return const Gap(8);
                        }
                      },
                      childCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? (state.libraries.length * 2) - 1
                          : (state.libraries.length * 2) + 1,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusWidget({required Widget child}) {
    return CupertinoRefreshPage(
      onRefresh: () {
        _librariesBloc.add(
          LibrariesFetched(
            server: _server,
            orderColumn: _orderColumn,
            orderDir: _orderDir,
            settingsBloc: _settingsBloc,
          ),
        );

        return _refreshCompleter.future;
      },
      sliver: SliverFillRemaining(child: child),
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

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Icon(
            CupertinoIcons.arrow_up_arrow_down,
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
          ),
          onPressed: () async {
            Map<String, String>? librarySort = await showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoStyleLibrariesFilterBottomSheet(
                orderColumn: _orderColumn,
                orderDir: _orderDir,
              ),
            );

            bool changed = false;

            if (librarySort != null && librarySort['orderColumn'] != _orderColumn) {
              _orderColumn = librarySort['orderColumn']!;
              changed = true;
            }
            if (librarySort != null && librarySort['orderDir'] != _orderDir) {
              _orderDir = librarySort['orderDir']!;
              changed = true;
            }

            if (changed) {
              _filterRefresh = true;
              _settingsBloc.add(SettingsUpdateLibrariesSort('$_orderColumn|$_orderDir'));
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
        ),
      ],
    );
  }
}
