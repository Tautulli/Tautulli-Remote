import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/core/widgets/page_body.dart';
import 'package:tautulli_remote/features/users/presentation/widgets/users_list.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/users_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

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
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late String _orderColumn;
  late String _orderDir;
  late UsersBloc _usersBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;

  @override
  void initState() {
    super.initState();
    _usersBloc = context.read<UsersBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final usersState = _usersBloc.state;
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;

    if (usersState is UsersInitial) {
      final usersSort = settingsState.appSettings.usersSort.split('|');
      _orderColumn = usersSort[0];
      _orderDir = usersSort[1];
    }

    context.read<UsersBloc>().add(
          UsersFetch(
            tautulliId: _tautulliId,
            orderColumn: _orderColumn,
            orderDir: _orderDir,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _tautulliId = state.appSettings.activeServer.tautulliId;
          context.read<UsersBloc>().add(
                UsersFetch(
                  tautulliId: _tautulliId,
                  orderColumn: _orderColumn,
                  orderDir: _orderDir,
                ),
              );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text('Users'),
        actions: _appBarActions(),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersInitial) {
              return UsersList(
                loading: true,
                displayMessage: false,
                users: state.users,
                tautulliId: _tautulliId,
                orderColumn: _orderColumn,
                orderDir: _orderDir,
              );
            }
            if (state is UsersSuccess) {
              return UsersList(
                loading: state.loading,
                users: state.users,
                tautulliId: _tautulliId,
                orderColumn: _orderColumn,
                orderDir: _orderDir,
              );
            }
            if (state is UsersFailure) {
              return ThemedRefreshIndicator(
                onRefresh: () {
                  _usersBloc.add(
                    UsersFetch(
                      tautulliId: _tautulliId,
                      orderColumn: _orderColumn,
                      orderDir: _orderDir,
                    ),
                  );

                  return Future.value(null);
                },
                child: PageBody(
                  loading: state.loading,
                  child: StatusPage(
                    scrollable: true,
                    message: state.message,
                    suggestion: state.suggestion,
                  ),
                ),
              );
            }
            return const LinearProgressIndicator();
          },
        ),
      ),
    );
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
          tooltip: 'Sort Users',
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
                UsersFetch(
                  tautulliId: _tautulliId,
                  orderColumn: _orderColumn,
                  orderDir: _orderDir,
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
                child: Row(
                  children: [
                    _orderColumn == 'friendly_name' && _orderDir == 'asc'
                        ? const FaIcon(
                            FontAwesomeIcons.sortAlphaDownAlt,
                            size: 20,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.sortAlphaDown,
                            size: 20,
                          ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Name'),
                    ),
                  ],
                ),
                value: _orderColumn == 'friendly_name' && _orderDir == 'asc'
                    ? 'friendly_name|desc'
                    : 'friendly_name|asc',
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    _orderColumn == 'last_seen' && _orderDir == 'desc'
                        ? const FaIcon(
                            FontAwesomeIcons.sortNumericDownAlt,
                            size: 20,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.sortNumericDown,
                            size: 20,
                          ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        'Last Streamed',
                      ),
                    ),
                  ],
                ),
                value: _orderColumn == 'last_seen' && _orderDir == 'desc'
                    ? 'last_seen|asc'
                    : 'last_seen|desc',
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
          FontAwesomeIcons.sortAlphaDown,
          size: 20,
          color: color,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.sortAlphaDownAlt,
          size: 20,
          color: color,
        );
      }
    }
    if (_orderColumn == 'last_seen') {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.sortNumericDownAlt,
          size: 20,
          color: color,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.sortNumericDown,
          size: 20,
          color: color,
        );
      }
    }

    return const FaIcon(FontAwesomeIcons.questionCircle);
  }

  String _currentSortName() {
    switch (_orderColumn) {
      case ('friendly_name'):
        return 'Name';
      case ('last_seen'):
        return 'Last Streamed';
      default:
        return 'Unknown';
    }
  }
}
