import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/users_bloc.dart';
import '../widgets/user_card.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UsersBloc>(),
      child: const UsersView(),
    );
  }
}

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final _scrollController = ScrollController();
  late String _orderColumn;
  late String _orderDir;
  late UsersBloc _usersBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _usersBloc = context.read<UsersBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;

    final usersSort = settingsState.appSettings.usersSort.split('|');
    _orderColumn = usersSort[0];
    _orderDir = usersSort[1];

    context.read<UsersBloc>().add(
          UsersFetched(
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
          if (previous.appSettings.activeServer !=
              current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _tautulliId = state.appSettings.activeServer.tautulliId;
          context.read<UsersBloc>().add(
                UsersFetched(
                  tautulliId: _tautulliId,
                  orderColumn: _orderColumn,
                  orderDir: _orderDir,
                  settingsBloc: _settingsBloc,
                ),
              );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.users_title).tr(),
        actions: _appBarActions(),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            return PageBody(
              loading:
                  state.status == UsersStatus.initial && !state.hasReachedMax,
              child: ThemedRefreshIndicator(
                onRefresh: () {
                  context.read<UsersBloc>().add(
                        UsersFetched(
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
                    if (state.users.isEmpty) {
                      if (state.status == UsersStatus.failure) {
                        return StatusPage(
                          scrollable: true,
                          message: state.message ?? '',
                          suggestion: state.suggestion ?? '',
                        );
                      }
                      if (state.status == UsersStatus.success) {
                        return StatusPage(
                          scrollable: true,
                          message: LocaleKeys.users_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax ||
                              state.status == UsersStatus.initial
                          ? state.users.length
                          : state.users.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.users.length) {
                          return BottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              context.read<UsersBloc>().add(
                                    UsersFetched(
                                      tautulliId: _tautulliId,
                                      orderColumn: _orderColumn,
                                      orderDir: _orderDir,
                                      settingsBloc: _settingsBloc,
                                    ),
                                  );
                            },
                          );
                        }

                        return UserCard(
                          key: ValueKey(state.users[index].userId!),
                          user: state.users[index],
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
      _usersBloc.add(
        UsersFetched(
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

  List<Widget> _appBarActions() {
    return [
      Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: DividerThemeData(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        child: PopupMenuButton(
          icon: _currentSortIcon(),
          tooltip: LocaleKeys.sort_users_title.tr(),
          onSelected: (value) {
            if (value != null) {
              value as String;
              List<String> values = value.split('|');

              setState(() {
                _orderColumn = values[0];
                _orderDir = values[1];
              });

              _settingsBloc.add(SettingsUpdateUsersSort(value));
              _usersBloc.add(
                UsersFetched(
                  tautulliId: _tautulliId,
                  orderColumn: _orderColumn,
                  orderDir: _orderDir,
                  freshFetch: true,
                  settingsBloc: _settingsBloc,
                ),
              );
            }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry<dynamic>>[
              PopupMenuItem(
                child: Row(
                  children: [
                    _currentSortIcon(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        _currentSortName(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: _orderColumn == 'friendly_name' && _orderDir == 'asc'
                    ? 'friendly_name|desc'
                    : 'friendly_name|asc',
                child: Row(
                  children: [
                    _orderColumn == 'friendly_name' && _orderDir == 'asc'
                        ? const FaIcon(
                            FontAwesomeIcons.arrowDownZA,
                            size: 20,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.arrowDownAZ,
                            size: 20,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: const Text(LocaleKeys.name_title).tr(),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _orderColumn == 'last_seen' && _orderDir == 'desc'
                    ? 'last_seen|asc'
                    : 'last_seen|desc',
                child: Row(
                  children: [
                    _orderColumn == 'last_seen' && _orderDir == 'desc'
                        ? const FaIcon(
                            FontAwesomeIcons.arrowDown91,
                            size: 20,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.arrowDown19,
                            size: 20,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: const Text(LocaleKeys.last_streamed_title).tr(),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      )
    ];
  }

  FaIcon _currentSortIcon({Color? color}) {
    if (_orderColumn == 'friendly_name') {
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
    }
    if (_orderColumn == 'last_seen') {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.arrowDown91,
          size: 20,
          color: color,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.arrowDown19,
          size: 20,
          color: color,
        );
      }
    }

    return const FaIcon(FontAwesomeIcons.circleQuestion);
  }

  String _currentSortName() {
    switch (_orderColumn) {
      case ('friendly_name'):
        return LocaleKeys.name_title.tr();
      case ('last_seen'):
        return LocaleKeys.last_streamed_title.tr();
      default:
        return 'Unknown';
    }
  }
}
