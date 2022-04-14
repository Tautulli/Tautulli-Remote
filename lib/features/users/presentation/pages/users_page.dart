import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();

    final settingsState = context.read<SettingsBloc>().state as SettingsSuccess;
    context.read<UsersBloc>().add(
          UsersFetch(
            tautulliId: settingsState.appSettings.activeServer.tautulliId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          context.read<UsersBloc>().add(
                UsersFetch(
                  tautulliId: state.appSettings.activeServer.tautulliId,
                ),
              );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text('Users'),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersInitial) {
              return UsersList(
                loading: true,
                displayMessage: false,
                users: state.users,
              );
            }
            if (state is UsersSuccess) {
              return UsersList(
                loading: state.loading,
                users: state.users,
              );
            }
            if (state is UsersFailure) {
              return ThemedRefreshIndicator(
                onRefresh: () {
                  final settingsState =
                      context.read<SettingsBloc>().state as SettingsSuccess;

                  context.read<UsersBloc>().add(
                        UsersFetch(
                          tautulliId:
                              settingsState.appSettings.activeServer.tautulliId,
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
}
