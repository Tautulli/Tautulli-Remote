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
import '../../bloc/users_table_bloc.dart';
import '../../widgets/ios/user_ios_card.dart';
import '../../widgets/ios/user_ios_details.dart';
import '../../widgets/ios/users_filter_ios_bottom_sheet.dart';

class UsersIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const UsersIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    this.refreshOnLoad = false,
  });

  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UsersTableBloc>(),
      child: UsersIosView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
        refreshOnLoad: refreshOnLoad,
      ),
    );
  }
}

class UsersIosView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const UsersIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.refreshOnLoad,
  });

  @override
  State<UsersIosView> createState() => _UsersIosViewState();
}

class _UsersIosViewState extends State<UsersIosView> {
  final _scrollController = ScrollController();
  late String _orderColumn;
  late String _orderDir;
  late UsersTableBloc _usersTableBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;
  late Completer<void> _refreshCompleter;
  bool _filterRefresh = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _usersTableBloc = context.read<UsersTableBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    final usersSort = settingsState.appSettings.usersSort.split('|');
    _orderColumn = usersSort[0];
    _orderDir = usersSort[1];

    _refreshCompleter = Completer<void>();

    context.read<UsersTableBloc>().add(
      UsersTableFetched(
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

          context.read<UsersTableBloc>().add(
            UsersTableFetched(
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
        middle: const Text(LocaleKeys.users_title).tr(),
        child: BlocConsumer<UsersTableBloc, UsersTableState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              _filterRefresh = false;
            }
          },
          builder: (context, state) {
            if (state.users.isEmpty) {
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
                  _usersTableBloc.add(
                    UsersTableFetched(
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

                        if (itemIndex >= state.users.length) {
                          return IosBottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              _usersTableBloc.add(
                                UsersTableFetched(
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
                          final user = state.users[itemIndex];

                          return UserIosCard(
                            server: _server,
                            user: user,
                            details: UserIosDetails(user: user),
                            currentPageTitle: LocaleKeys.users_title.tr(),
                          );
                        } else {
                          return const Gap(8);
                        }
                      },
                      childCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? (state.users.length * 2) - 1
                          : (state.users.length * 2) + 1,
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
        _usersTableBloc.add(
          UsersTableFetched(
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
      _usersTableBloc.add(
        UsersTableFetched(
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
            Map<String, String>? usersSort = await showCupertinoModalPopup(
              context: context,
              builder: (_) => UsersFilterIosBottomSheet(
                orderColumn: _orderColumn,
                orderDir: _orderDir,
              ),
            );

            bool changed = false;

            if (usersSort != null && usersSort['orderColumn'] != _orderColumn) {
              _orderColumn = usersSort['orderColumn']!;
              changed = true;
            }
            if (usersSort != null && usersSort['orderDir'] != _orderDir) {
              _orderDir = usersSort['orderDir']!;
              changed = true;
            }

            if (changed) {
              _filterRefresh = true;
              _settingsBloc.add(SettingsUpdateUsersSort('$_orderColumn|$_orderDir'));
              _usersTableBloc.add(
                UsersTableFetched(
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
