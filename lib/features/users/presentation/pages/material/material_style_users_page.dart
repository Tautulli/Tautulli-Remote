import 'dart:async';

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
import '../../bloc/users_table_bloc.dart';
import '../../widgets/material/bottom_sheets/material_style_users_sort_bottom_sheet.dart';
import '../../widgets/material/material_style_user_card.dart';
import '../../widgets/base/user_details.dart';

class MaterialStyleUsersPage extends StatelessWidget {
  const MaterialStyleUsersPage({super.key});

  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UsersTableBloc>(param1: context.read<SettingsBloc>()),
      child: const MaterialStyleUsersView(),
    );
  }
}

class MaterialStyleUsersView extends StatefulWidget {
  const MaterialStyleUsersView({super.key});

  @override
  State<MaterialStyleUsersView> createState() => _MaterialStyleUsersViewState();
}

class _MaterialStyleUsersViewState extends State<MaterialStyleUsersView> {
  final _scrollController = ScrollController();
  late String _orderColumn;
  late String _orderDir;
  late UsersTableBloc _usersTableBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;

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

    context.read<UsersTableBloc>().add(
      UsersTableFetched(
        server: _server,
        orderColumn: _orderColumn,
        orderDir: _orderDir,
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
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;
          context.read<UsersTableBloc>().add(
            UsersTableFetched(
              server: _server,
              orderColumn: _orderColumn,
              orderDir: _orderDir,
            ),
          );
        }
      },
      child: MaterialStyleScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.users_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<UsersTableBloc, UsersTableState>(
          builder: (context, state) {
            return MaterialStylePageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: MaterialStyleRefreshIndicator(
                onRefresh: () {
                  context.read<UsersTableBloc>().add(
                    UsersTableFetched(
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
                    if (state.users.isEmpty) {
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
                          message: LocaleKeys.users_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? state.users.length
                          : state.users.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.users.length) {
                          return MaterialStyleBottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              context.read<UsersTableBloc>().add(
                                UsersTableFetched(
                                  server: _server,
                                  orderColumn: _orderColumn,
                                  orderDir: _orderDir,
                                ),
                              );
                            },
                          );
                        }

                        return MaterialStyleUserCard(
                          key: ValueKey(state.users[index].userId!),
                          server: _server,
                          user: state.users[index],
                          details: UserDetails(
                            user: state.users[index],
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
      _usersTableBloc.add(
        UsersTableFetched(
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
        tooltip: LocaleKeys.sort_users_title.tr(),
        icon: FaIcon(
          FontAwesomeIcons.upDown,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<Map<String, String>>(
            context: context,
            isScrollControlled: true,
            builder: (_) => MaterialStyleUsersSortBottomSheet(
              orderColumn: _orderColumn,
              orderDir: _orderDir,
            ),
          );

          if (result != null &&
              (result['orderColumn'] != _orderColumn || result['orderDir'] != _orderDir)) {
            setState(() {
              _orderColumn = result['orderColumn']!;
              _orderDir = result['orderDir']!;
            });

            _settingsBloc.add(SettingsUpdateUsersSort('$_orderColumn|$_orderDir'));
            _usersTableBloc.add(
              UsersTableFetched(
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
