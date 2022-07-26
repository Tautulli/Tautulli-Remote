import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../../../core/helpers/quick_actions_helper.dart';
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
  final QuickActions quickActions = const QuickActions();
  final _scrollController = ScrollController();
  late LibrariesBloc _librariesBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;
  late String _orderColumn;
  late String _orderDir;

  @override
  void initState() {
    super.initState();
    initalizeQuickActions(context, quickActions);

    _scrollController.addListener(_onScroll);
    _librariesBloc = context.read<LibrariesBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;

    _orderColumn = _librariesBloc.state.orderColumn;
    _orderDir = _librariesBloc.state.orderDir;

    _librariesBloc.add(
      LibrariesFetched(
        tautulliId: _tautulliId,
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
          _tautulliId = state.appSettings.activeServer.tautulliId;

          _librariesBloc.add(
            LibrariesFetched(
              tautulliId: _tautulliId,
              orderColumn: _orderColumn,
              orderDir: _orderDir,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.libraries_title).tr(),
        body: BlocBuilder<LibrariesBloc, LibrariesState>(
          builder: (context, state) {
            return PageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: ThemedRefreshIndicator(
                onRefresh: () {
                  _librariesBloc.add(
                    LibrariesFetched(
                      tautulliId: _tautulliId,
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
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? state.libraries.length
                          : state.libraries.length + 1,
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
                                  tautulliId: _tautulliId,
                                  orderColumn: _orderColumn,
                                  orderDir: _orderDir,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        final library = state.libraries[index];

                        return LibraryCard(library: library);
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
          tautulliId: _tautulliId,
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
}
