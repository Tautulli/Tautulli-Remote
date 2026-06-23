import 'package:badges/badges.dart' as badges;
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
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../core/widgets/material/material_style_scaffold_with_inner_drawer.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';
import '../../bloc/history_bloc.dart';
import '../../../../../core/widgets/material/bottom_sheets/material_style_user_filter_bottom_sheet.dart';
import '../../widgets/material/bottom_sheets/material_style_history_actions_bottom_sheet.dart';
import '../../widgets/material/bottom_sheets/material_style_history_filter_bottom_sheet.dart';
import '../../widgets/material/material_style_history_card.dart';
import 'material_style_history_search_page.dart';

class MaterialStyleHistoryPage extends StatelessWidget {
  const MaterialStyleHistoryPage({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final refreshOnLoad = args?['refreshOnLoad'] as bool? ?? false;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<HistoryBloc>(param1: context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (context) => di.sl<UsersBloc>(param1: context.read<SettingsBloc>()),
        ),
      ],
      child: MaterialStyleHistoryView(refreshOnLoad: refreshOnLoad),
    );
  }
}

class MaterialStyleHistoryView extends StatefulWidget {
  final bool refreshOnLoad;

  const MaterialStyleHistoryView({
    super.key,
    required this.refreshOnLoad,
  });

  @override
  State<MaterialStyleHistoryView> createState() => _MaterialStyleHistoryViewState();
}

class _MaterialStyleHistoryViewState extends State<MaterialStyleHistoryView> {
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
    _movieMediaType = _filterMap['movie'] ?? true;
    _episodeMediaType = _filterMap['episode'] ?? true;
    _trackMediaType = _filterMap['track'] ?? true;
    _liveMediaType = _filterMap['live'] ?? true;
    _directPlayDecision = _filterMap['directPlay'] ?? true;
    _directStreamDecision = _filterMap['directStream'] ?? true;
    _transcodeDecision = _filterMap['transcode'] ?? true;

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
      ),
    );

    _usersBloc.add(
      UsersFetched(
        server: _server,
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
            ),
          );
          _usersBloc.add(
            UsersFetched(
              server: _server,
            ),
          );
        }
      },
      child: MaterialStyleScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.history_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return MaterialStylePageBody(
              loading: state.status == BlocStatus.initial && !state.hasReachedMax,
              child: MaterialStyleRefreshIndicator(
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
                    ),
                  );

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (state.history.isEmpty) {
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
                          message: LocaleKeys.history_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? state.history.length
                          : state.history.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.history.length) {
                          return MaterialStyleBottomLoader(
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
                                ),
                              );
                            },
                          );
                        }

                        final history = state.history[index];

                        return MaterialStyleHistoryCard(
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
                child: const MaterialStyleHistorySearchPage(),
              ),
            ),
          );
        },
      ),
      IconButton(
        tooltip: LocaleKeys.history_actions_title.tr(),
        icon: badges.Badge(
          showBadge: (_userId != null && _userId != -1) || _filterOptionSelected(),
          badgeAnimation: const badges.BadgeAnimation.fade(toAnimate: false),
          position: badges.BadgePosition.bottomEnd(bottom: -5, end: -5),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Theme.of(context).colorScheme.primary,
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: FaIcon(
            FontAwesomeIcons.sliders,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<UsersBloc>(),
              child: MaterialStyleHistoryActionsBottomSheet(
                userId: _userId,
                filterApplied: _filterOptionSelected(),
              ),
            ),
          );

          if (!mounted) return;

          if (result == 'user') {
            final newUserId = await showModalBottomSheet<int>(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: context.read<UsersBloc>(),
                child: MaterialStyleUserFilterBottomSheet(
                  initialValue: _userId ?? -1,
                ),
              ),
            );

            if (newUserId != null && newUserId != _userId) {
              setState(() {
                _userId = newUserId;
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
                ),
              );
            }
          } else if (result == 'filter') {
            final updatedMap = await showModalBottomSheet<Map<String, bool>>(
              context: context,
              isScrollControlled: true,
              builder: (_) => MaterialStyleHistoryFilterBottomSheet(
                filterMap: _filterMap,
              ),
            );

            if (updatedMap != null) {
              setState(() {
                _filterMap = updatedMap;
                _movieMediaType = updatedMap['movie'] ?? true;
                _episodeMediaType = updatedMap['episode'] ?? true;
                _trackMediaType = updatedMap['track'] ?? true;
                _liveMediaType = updatedMap['live'] ?? true;
                _directPlayDecision = updatedMap['directPlay'] ?? true;
                _directStreamDecision = updatedMap['directStream'] ?? true;
                _transcodeDecision = updatedMap['transcode'] ?? true;
              });

              _settingsBloc.add(SettingsUpdateHistoryFilter(updatedMap));

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
                ),
              );
            }
          } else if (result == 'clear') {
            setState(() {
              _userId = -1;
              _movieMediaType = true;
              _episodeMediaType = true;
              _trackMediaType = true;
              _liveMediaType = true;
              _directPlayDecision = true;
              _directStreamDecision = true;
              _transcodeDecision = true;
              _filterMap = {
                'movie': true,
                'episode': true,
                'track': true,
                'live': true,
                'directPlay': true,
                'directStream': true,
                'transcode': true,
              };
            });

            _settingsBloc.add(SettingsUpdateHistoryFilter(_filterMap));

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
              ),
            );
          }
        },
      ),
    ];
  }

  bool _filterOptionSelected() {
    return !_movieMediaType ||
        !_episodeMediaType ||
        !_trackMediaType ||
        !_liveMediaType ||
        !_directPlayDecision ||
        !_directStreamDecision ||
        !_transcodeDecision;
  }
}
