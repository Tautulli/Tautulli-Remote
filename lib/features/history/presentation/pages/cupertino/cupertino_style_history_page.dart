import 'dart:async';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/global_keys/global_keys.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_bottom_loader.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../core/widgets/cupertino/bottom_sheets/cupertino_style_user_filter_bottom_sheet.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';
import '../../bloc/history_bloc.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_history_actions_bottom_sheet.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_history_filter_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_history_card.dart';
import 'cupertino_style_history_search_page.dart';

class CupertinoStyleHistoryPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const CupertinoStyleHistoryPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
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
      child: CupertinoStyleHistoryView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
        refreshOnLoad: refreshOnLoad,
      ),
    );
  }
}

class CupertinoStyleHistoryView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const CupertinoStyleHistoryView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.refreshOnLoad,
  });

  @override
  State<CupertinoStyleHistoryView> createState() => _CupertinoStyleHistoryViewState();
}

class _CupertinoStyleHistoryViewState extends State<CupertinoStyleHistoryView> {
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
  late Completer<void> _refreshCompleter;
  bool _filterRefresh = true;

  @override
  void initState() {
    super.initState();

    historyRefreshNotifier.addListener(_onRefreshRequest);
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

    _refreshCompleter = Completer<void>();

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
    return //* If active server is changed trigger a HistoryFetched
    BlocListener<SettingsBloc, SettingsState>(
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
          _userId = -1;
          _filterRefresh = true;

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
      child: CupertinoStylePageScaffold(
        showBackButton: widget.showBackButton,
        previousPageTitle: widget.previousPageTitle,
        showServerSelect: true,
        trailing: _navBarActions(),
        middle: const Text(LocaleKeys.history_title).tr(),
        child: BlocConsumer<HistoryBloc, HistoryState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              _filterRefresh = false;
            }
          },
          builder: (context, state) {
            if (state.history.isEmpty) {
              if (state.status == BlocStatus.failure) {
                return _statusWidget(
                  child: CupertinoStyleStatusPage(
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  ),
                );
              }
              if (state.status == BlocStatus.success) {
                return _statusWidget(
                  child: CupertinoStyleStatusPage(
                    message: LocaleKeys.history_empty_message.tr(),
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
              child: CupertinoStyleRefreshPage(
                scrollController: _scrollController,
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

                  return _refreshCompleter.future;
                },
                sliver: SliverPadding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final itemIndex = index ~/ 2;

                        if (itemIndex >= state.history.length) {
                          return CupertinoStyleBottomLoader(
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

                        if (index.isEven) {
                          final history = state.history[itemIndex];

                          return CupertinoStyleHistoryCard(
                            server: _server,
                            history: history,
                            viewMediaEnabled: history.live != true,
                            currentPageTitle: LocaleKeys.history_title.tr(),
                          );
                        } else {
                          return const Gap(8);
                        }
                      },
                      childCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? (state.history.length * 2) - 1
                          : (state.history.length * 2) + 1,
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
    return CupertinoStyleRefreshPage(
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
    historyRefreshNotifier.removeListener(_onRefreshRequest);
    super.dispose();
  }

  void _onRefreshRequest() {
    if (!historyRefreshNotifier.value) return;
    historyRefreshNotifier.value = false;
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

  bool _filterOptionSelected() {
    return !_movieMediaType ||
        !_episodeMediaType ||
        !_trackMediaType ||
        !_liveMediaType ||
        !_directPlayDecision ||
        !_directStreamDecision ||
        !_transcodeDecision;
  }

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Icon(
            CupertinoIcons.search,
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
          ),
          onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<UsersBloc>(),
                child: CupertinoStyleHistorySearchPage(
                  previousPageTitle: LocaleKeys.history_title.tr(),
                ),
              ),
            ),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Badge(
            showBadge: _userId != -1 || _filterOptionSelected(),
            position: BadgePosition.bottomEnd(bottom: -3, end: -3),
            badgeStyle: BadgeStyle(
              badgeColor: CupertinoTheme.of(context).primaryColor,
              borderSide: BorderSide(
                width: 2,
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
              ),
            ),
            child: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: ThemeHelper.cupertinoNavigationBarItemColor(),
            ),
          ),
          onPressed: () async {
            String? result = await showCupertinoModalPopup(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<UsersBloc>(),
                child: CupertinoStyleHistoryActionsBottomSheet(
                  userId: _userId,
                  filterApplied: _filterOptionSelected(),
                ),
              ),
            );

            if (result == 'user') {
              int? newUserId = await showCupertinoModalPopup(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<UsersBloc>(),
                  child: CupertinoStyleUserFilterBottomSheet(
                    initialValue: _userId!,
                  ),
                ),
              );

              if (newUserId != null && newUserId != _userId) {
                setState(() {
                  _userId = newUserId;

                  _filterRefresh = true;

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
                });
              }
            }
            if (result == 'filter') {
              final bool? filterUnchanged = await showCupertinoModalPopup(
                context: context,
                builder: (_) => CupertinoStyleHistoryFilterBottomSheet(
                  filterMap: _filterMap,
                ),
              );

              if (filterUnchanged == false) {
                _settingsBloc.add(SettingsUpdateHistoryFilter(_filterMap));

                setState(() {
                  _movieMediaType = _filterMap['movie'] ?? true;
                  _episodeMediaType = _filterMap['episode'] ?? true;
                  _trackMediaType = _filterMap['track'] ?? true;
                  _liveMediaType = _filterMap['live'] ?? true;
                  _directPlayDecision = _filterMap['directPlay'] ?? true;
                  _directStreamDecision = _filterMap['directStream'] ?? true;
                  _transcodeDecision = _filterMap['transcode'] ?? true;

                  _filterRefresh = true;
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
              }
            }
            if (result == 'clear') {
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
                  'movie': _movieMediaType,
                  'episode': _episodeMediaType,
                  'track': _trackMediaType,
                  'live': _liveMediaType,
                  'directPlay': _directPlayDecision,
                  'directStream': _directStreamDecision,
                  'transcode': _transcodeDecision,
                };

                _filterRefresh = true;
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
