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
import '../../../users/presentation/bloc/users_bloc.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_card.dart';
import 'history_search_page.dart';

class HistoryPage extends StatelessWidget {
  final bool refreshOnLoad;

  const HistoryPage({
    super.key,
    this.refreshOnLoad = false,
  });

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<HistoryBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UsersBloc>(),
        ),
      ],
      child: HistoryView(refreshOnLoad: refreshOnLoad),
    );
  }
}

class HistoryView extends StatefulWidget {
  final bool refreshOnLoad;

  const HistoryView({
    super.key,
    required this.refreshOnLoad,
  });

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final _scrollController = ScrollController();
  late ServerModel _server;
  late HistoryBloc _historyBloc;
  late UsersBloc _usersBloc;
  late SettingsBloc _settingsBloc;
  late int? _userId;
  late Map<String, bool> _filterMap;
  late bool _movieMediaType;
  late bool _episodeMediaType;
  late bool _trackMediaType;
  late bool _liveMediaType;
  late bool _directPlayDecision;
  late bool _directStreamDecision;
  late bool _transcodeDecision;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _historyBloc = context.read<HistoryBloc>();
    _usersBloc = context.read<UsersBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    _userId = _historyBloc.state.userId ?? -1;

    _filterMap = settingsState.appSettings.historyFilter;
    _movieMediaType = _filterMap['movie'] ?? false;
    _episodeMediaType = _filterMap['episode'] ?? false;
    _trackMediaType = _filterMap['track'] ?? false;
    _liveMediaType = _filterMap['live'] ?? false;
    _directPlayDecision = _filterMap['directPlay'] ?? false;
    _directStreamDecision = _filterMap['directStream'] ?? false;
    _transcodeDecision = _filterMap['transcode'] ?? false;

    _historyBloc.add(
      HistoryFetched(
        server: _server,
        userId: _userId,
        movieMediaType: _movieMediaType,
        episodeMediaType: _episodeMediaType,
        trackMediaType: _trackMediaType,
        liveMediaType: _liveMediaType,
        directPlayDecision: _directPlayDecision,
        directStreamDecision: _directStreamDecision,
        transcodeDecision: _transcodeDecision,
        freshFetch: widget.refreshOnLoad,
        settingsBloc: _settingsBloc,
      ),
    );

    _usersBloc.add(
      UsersFetched(
        server: _server,
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
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;
          _userId = null;

          _historyBloc.add(
            HistoryFetched(
              server: _server,
              userId: _userId,
              movieMediaType: _movieMediaType,
              episodeMediaType: _episodeMediaType,
              trackMediaType: _trackMediaType,
              liveMediaType: _liveMediaType,
              directPlayDecision: _directPlayDecision,
              directStreamDecision: _directStreamDecision,
              transcodeDecision: _transcodeDecision,
              settingsBloc: _settingsBloc,
            ),
          );
          _usersBloc.add(
            UsersFetched(
              server: _server,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.history_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return PageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: ThemedRefreshIndicator(
                onRefresh: () {
                  _historyBloc.add(
                    HistoryFetched(
                      server: _server,
                      userId: _userId,
                      movieMediaType: _movieMediaType,
                      episodeMediaType: _episodeMediaType,
                      trackMediaType: _trackMediaType,
                      liveMediaType: _liveMediaType,
                      directPlayDecision: _directPlayDecision,
                      directStreamDecision: _directStreamDecision,
                      transcodeDecision: _transcodeDecision,
                      freshFetch: true,
                      settingsBloc: _settingsBloc,
                    ),
                  );

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (state.history.isEmpty) {
                      if (state.status == BlocStatus.failure) {
                        return StatusPage(
                          scrollable: true,
                          message: state.message ?? '',
                          suggestion: state.suggestion ?? '',
                        );
                      }
                      if (state.status == BlocStatus.success) {
                        return StatusPage(
                          scrollable: true,
                          message: LocaleKeys.history_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial ? state.history.length : state.history.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.history.length) {
                          return BottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              _historyBloc.add(
                                HistoryFetched(
                                  server: _server,
                                  userId: _userId,
                                  movieMediaType: _movieMediaType,
                                  episodeMediaType: _episodeMediaType,
                                  trackMediaType: _trackMediaType,
                                  liveMediaType: _liveMediaType,
                                  directPlayDecision: _directPlayDecision,
                                  directStreamDecision: _directStreamDecision,
                                  transcodeDecision: _transcodeDecision,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        final history = state.history[index];

                        return HistoryCard(
                          server: _server,
                          history: history,
                          viewMediaEnabled: history.live != true,
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
      _historyBloc.add(
        HistoryFetched(
          server: _server,
          userId: _userId,
          movieMediaType: _movieMediaType,
          episodeMediaType: _episodeMediaType,
          trackMediaType: _trackMediaType,
          liveMediaType: _liveMediaType,
          directPlayDecision: _directPlayDecision,
          directStreamDecision: _directStreamDecision,
          transcodeDecision: _transcodeDecision,
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
      IconButton(
        tooltip: LocaleKeys.search_history_title.tr(),
        icon: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<UsersBloc>(),
                child: const HistorySearchPage(),
              ),
            ),
          );
        },
      ),
      BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: PopupMenuButton(
                  enabled: state.status == BlocStatus.success,
                  icon: FaIcon(
                    state.status == BlocStatus.failure ? FontAwesomeIcons.userSlash : FontAwesomeIcons.solidUser,
                    color: (_userId != -1 && _userId != null) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                  tooltip: LocaleKeys.select_user_title.tr(),
                  onSelected: (value) {
                    setState(() {
                      _userId = value as int;
                    });

                    _historyBloc.add(
                      HistoryFetched(
                        server: _server,
                        userId: _userId,
                        movieMediaType: _movieMediaType,
                        episodeMediaType: _episodeMediaType,
                        trackMediaType: _trackMediaType,
                        liveMediaType: _liveMediaType,
                        directPlayDecision: _directPlayDecision,
                        directStreamDecision: _directStreamDecision,
                        transcodeDecision: _transcodeDecision,
                        freshFetch: true,
                        settingsBloc: _settingsBloc,
                      ),
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  itemBuilder: (context) {
                    return state.users
                        .map(
                          (user) => PopupMenuItem(
                            value: user.userId,
                            child: BlocBuilder<SettingsBloc, SettingsState>(
                              builder: (context, state) {
                                state as SettingsSuccess;

                                return Text(
                                  state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : user.friendlyName ?? '',
                                  style: TextStyle(
                                    color: _userId == user.userId! ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .toList();
                  },
                ),
              ),
              if (state.status == BlocStatus.initial)
                Positioned(
                  bottom: 12,
                  right: 10,
                  child: SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      // Wrapped in BlocBuilder to update the filter icon state when the server
      // is changed.
      BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return PopupMenuButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
              color: _filterOptionSelected() ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            tooltip: LocaleKeys.filter_history_title.tr(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            itemBuilder: _filterOptions,
          );
        },
      ),
    ];
  }

  bool _filterOptionSelected() {
    return _movieMediaType || _episodeMediaType || _trackMediaType || _liveMediaType || _directPlayDecision || _directStreamDecision || _transcodeDecision;
  }

  List<PopupMenuEntry<Object?>> _filterOptions(BuildContext context) {
    ValueNotifier<bool> movieMediaTypeNotifier = ValueNotifier(_movieMediaType);
    ValueNotifier<bool> episodeMediaTypeNotifier = ValueNotifier(_episodeMediaType);
    ValueNotifier<bool> trackMediaTypeNotifier = ValueNotifier(_trackMediaType);
    ValueNotifier<bool> liveMediaTypeNotifier = ValueNotifier(_liveMediaType);
    ValueNotifier<bool> directPlayDecisionNotifier = ValueNotifier(_directPlayDecision);
    ValueNotifier<bool> directStreamDecisionNotifier = ValueNotifier(_directStreamDecision);
    ValueNotifier<bool> transcodeDecisionNotifier = ValueNotifier(_transcodeDecision);

    return [
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: movieMediaTypeNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(LocaleKeys.movies_title.tr()),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _movieMediaType,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _movieMediaType = value;
                    _filterMap['movie'] = value;
                  });
                  _filterChanged(
                    valueNotifier: movieMediaTypeNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: episodeMediaTypeNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(LocaleKeys.tv_shows_title.tr()),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _episodeMediaType,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _episodeMediaType = value;
                    _filterMap['episode'] = value;
                  });
                  _filterChanged(
                    valueNotifier: episodeMediaTypeNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: trackMediaTypeNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(LocaleKeys.music_title.tr()),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _trackMediaType,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _trackMediaType = value;
                    _filterMap['track'] = value;
                  });
                  _filterChanged(
                    valueNotifier: trackMediaTypeNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: liveMediaTypeNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(LocaleKeys.live_tv_title.tr()),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _liveMediaType,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _liveMediaType = value;
                    _filterMap['live'] = value;
                  });
                  _filterChanged(
                    valueNotifier: liveMediaTypeNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: directPlayDecisionNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              LocaleKeys.direct_play_title.tr(),
            ),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _directPlayDecision,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _directPlayDecision = value;
                    _filterMap['directPlay'] = value;
                  });
                  _filterChanged(
                    valueNotifier: directPlayDecisionNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: directStreamDecisionNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              LocaleKeys.direct_stream_title.tr(),
            ),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _directStreamDecision,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _directStreamDecision = value;
                    _filterMap['directStream'] = value;
                  });
                  _filterChanged(
                    valueNotifier: directStreamDecisionNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
      PopupMenuItem(
        padding: const EdgeInsets.all(0),
        child: AnimatedBuilder(
          animation: transcodeDecisionNotifier,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              LocaleKeys.transcode_title.tr(),
            ),
          ),
          builder: (context, child) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _transcodeDecision,
              title: child,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _transcodeDecision = value;
                    _filterMap['transcode'] = value;
                  });
                  _filterChanged(
                    valueNotifier: transcodeDecisionNotifier,
                    value: value,
                  );
                }
              },
            );
          },
        ),
      ),
    ];
  }

  void _filterChanged({
    required ValueNotifier<bool> valueNotifier,
    required bool value,
  }) {
    _settingsBloc.add(SettingsUpdateHistoryFilter(_filterMap));

    valueNotifier.value = value;
    _historyBloc.add(
      HistoryFetched(
        server: _server,
        userId: _userId,
        movieMediaType: _movieMediaType,
        episodeMediaType: _episodeMediaType,
        trackMediaType: _trackMediaType,
        liveMediaType: _liveMediaType,
        directPlayDecision: _directPlayDecision,
        directStreamDecision: _directStreamDecision,
        transcodeDecision: _transcodeDecision,
        freshFetch: true,
        settingsBloc: _settingsBloc,
      ),
    );
  }
}
