import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../core/widgets/user_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/users_bloc.dart';
import '../widgets/user_details.dart';
import '../widgets/user_error_button.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key key}) : super(key: key);

  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersBloc>(
      create: (context) => di.sl<UsersBloc>(),
      child: const UsersPageContent(),
    );
  }
}

class UsersPageContent extends StatefulWidget {
  const UsersPageContent({Key key}) : super(key: key);

  @override
  _UsersPageContentState createState() => _UsersPageContentState();
}

class _UsersPageContentState extends State<UsersPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  UsersBloc _usersBloc;
  String _tautulliId;
  String _orderColumn;
  String _orderDir;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _usersBloc = context.read<UsersBloc>();

    final usersState = _usersBloc.state;
    final settingState = _settingsBloc.state;

    if (settingState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingState.maskSensitiveInfo;

      if (settingState.lastSelectedServer != null) {
        for (Server server in settingState.serverList) {
          if (server.tautulliId == settingState.lastSelectedServer) {
            lastSelectedServer = settingState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingState.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
      }

      if (usersState is UsersInitial) {
        final usersSort = settingState.usersSort.split('|');
        _orderColumn = usersSort[0];
        _orderDir = usersSort[1];
      }

      _usersBloc.add(
        UsersFetch(
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
          LocaleKeys.users_page_title.tr(),
        ),
        actions: _appBarActions(),
      ),
      drawer: const AppDrawer(),
      body: DoubleTapExit(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
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
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                              items: state.serverList.map((server) {
                                return DropdownMenuItem(
                                  child:
                                      ServerHeader(serverName: server.plexName),
                                  value: server.tautulliId,
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != _tautulliId) {
                                  setState(() {
                                    _tautulliId = value;
                                    _settingsBloc.add(
                                      SettingsUpdateLastSelectedServer(
                                          tautulliId: _tautulliId),
                                    );
                                    _usersBloc.add(
                                      UsersFilter(
                                        tautulliId: _tautulliId,
                                        orderColumn: _orderColumn,
                                        orderDir: _orderDir,
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                          );
                        }
                      }
                      return Container(height: 0, width: 0);
                    },
                  ),
                  BlocConsumer<UsersBloc, UsersState>(
                    listener: (context, state) {
                      if (state is UsersSuccess) {
                        _refreshCompleter?.complete();
                        _refreshCompleter = Completer();
                      }
                    },
                    builder: (context, state) {
                      if (state is UsersSuccess) {
                        if (state.list.isNotEmpty) {
                          return Expanded(
                            child: RefreshIndicator(
                              color: Theme.of(context).accentColor,
                              onRefresh: () {
                                _usersBloc.add(
                                  UsersFilter(
                                    tautulliId: _tautulliId,
                                    orderColumn: _orderColumn,
                                    orderDir: _orderDir,
                                  ),
                                );
                                return _refreshCompleter.future;
                              },
                              child: Scrollbar(
                                child: ListView.builder(
                                  itemCount: state.hasReachedMax
                                      ? state.list.length
                                      : state.list.length + 1,
                                  controller: _scrollController,
                                  itemBuilder: (context, index) {
                                    return index >= state.list.length
                                        ? BottomLoader()
                                        : UserCard(
                                            user: state.list[index],
                                            details: UsersDetails(
                                              user: state.list[index],
                                              maskSensitiveInfo:
                                                  _maskSensitiveInfo,
                                            ),
                                            maskSensitiveInfo:
                                                _maskSensitiveInfo,
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
                                LocaleKeys.users_empty,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ).tr(),
                            ),
                          );
                        }
                      }
                      if (state is UsersFailure) {
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
                                UserErrorButton(
                                  completer: _refreshCompleter,
                                  failure: state.failure,
                                  usersEvent: UsersFilter(
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _usersBloc.add(
        UsersFetch(
          tautulliId: _tautulliId,
          orderColumn: _orderColumn,
          orderDir: _orderDir,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        icon: _currentSortIcon(),
        tooltip: LocaleKeys.general_tooltip_sort_users.tr(),
        onSelected: (value) {
          List<String> values = value.split('|');

          setState(() {
            _orderColumn = values[0];
            _orderDir = values[1];
          });
          _settingsBloc.add(SettingsUpdateUsersSort(usersSort: value));
          _usersBloc.add(
            UsersFilter(
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
                  _orderColumn == 'friendly_name' && _orderDir == 'asc'
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
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.sortNumericDown,
                          color: TautulliColorPalette.not_white,
                          size: 20,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const Text(
                      LocaleKeys.general_filter_last_streamed,
                    ).tr(),
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
    ];
  }

  FaIcon _currentSortIcon({Color color}) {
    if (_orderColumn == 'friendly_name') {
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
    }
    if (_orderColumn == 'last_seen') {
      if (_orderDir == 'asc') {
        return FaIcon(
          FontAwesomeIcons.sortNumericDownAlt,
          size: 20,
          color: color ?? TautulliColorPalette.not_white,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.sortNumericDown,
          size: 20,
          color: color ?? TautulliColorPalette.not_white,
        );
      }
    }

    return const FaIcon(FontAwesomeIcons.questionCircle);
  }

  String _currentSortName() {
    switch (_orderColumn) {
      case ('friendly_name'):
        return LocaleKeys.general_filter_name.tr();
      case ('last_seen'):
        return LocaleKeys.general_filter_last_streamed.tr();
      default:
        return LocaleKeys.media_details_unknown.tr();
    }
  }
}
