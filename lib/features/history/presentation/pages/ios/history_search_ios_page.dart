import 'dart:async';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/ios_bottom_loader.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';
import '../../bloc/search_history_bloc.dart';
import '../../widgets/ios/history_actions_action_sheet.dart';
import '../../widgets/ios/history_filter_ios_bottom_sheet.dart';
import '../../widgets/ios/history_ios_card.dart';
import '../../widgets/ios/history_user_filter_ios_bottom_sheet.dart';

class HistorySearchIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const HistorySearchIosPage({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchHistoryBloc>(),
      child: HistorySearchIosView(
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class HistorySearchIosView extends StatefulWidget {
  final String? previousPageTitle;

  const HistorySearchIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  State<HistorySearchIosView> createState() => _HistorySearchIosViewState();
}

class _HistorySearchIosViewState extends State<HistorySearchIosView> {
  bool _firstPageLoad = true;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _hasContent = false;
  final _scrollController = ScrollController();
  late ServerModel _server;
  late SearchHistoryBloc _searchHistoryBloc;
  late SettingsBloc _settingsBloc;
  int _userId = -1;
  Map<String, bool> _filterMap = {};
  bool _movieMediaType = true;
  bool _episodeMediaType = true;
  bool _trackMediaType = true;
  bool _liveMediaType = true;
  bool _directPlayDecision = true;
  bool _directStreamDecision = true;
  bool _transcodeDecision = true;
  late Completer<void> _refreshCompleter;
  bool _filterRefresh = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _searchHistoryBloc = context.read<SearchHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      //TODO: Translation string
      middle: const Text('Search History'),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: widget.previousPageTitle,
      ),
      trailing: _navBarActions(),
      child: BlocConsumer<SearchHistoryBloc, SearchHistoryState>(
        listener: (context, state) {
          if (_firstPageLoad && state.status != BlocStatus.initial) {
            _firstPageLoad = false;
          }

          if ([BlocStatus.success, BlocStatus.failure].contains(state.status)) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
            _filterRefresh = false;
          }
        },
        builder: (context, state) {
          if (_firstPageLoad) {
            return _searchBar();
          }

          if (state.history.isEmpty) {
            if (state.status == BlocStatus.failure) {
              return Column(
                children: [
                  _searchBar(),
                  Expanded(
                    child: _statusWidget(
                      child: StatusIosPage(
                        message: state.message ?? '',
                        suggestion: state.suggestion ?? '',
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state.status == BlocStatus.success) {
              return Column(
                children: [
                  _searchBar(),
                  Expanded(
                    child: _statusWidget(
                      child: StatusIosPage(
                        message: LocaleKeys.history_empty_message.tr(),
                      ),
                    ),
                  ),
                ],
              );
            }
          }

          if (_filterRefresh && [BlocStatus.initial, BlocStatus.inProgress].contains(state.status)) {
            return Column(
              children: [
                _searchBar(),
                const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _searchBar(),
              Expanded(
                child: CupertinoScrollbar(
                  controller: _scrollController,
                  child: CupertinoRefreshPage(
                    scrollController: _scrollController,
                    onRefresh: null,
                    //TODO: Could this be made a SliverFixedExtentList and just result in bottom loader being larger?
                    sliver: SliverPadding(
                      padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final itemIndex = index ~/ 2;

                            if (itemIndex >= state.history.length) {
                              return IosBottomLoader(
                                status: state.status,
                                failure: state.failure,
                                message: state.message,
                                suggestion: state.suggestion,
                                onTap: () {
                                  _searchHistoryBloc.add(
                                    SearchHistoryFetched(
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

                              return HistoryIosCard(
                                server: _server,
                                history: history,
                                viewMediaEnabled: history.live != true,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statusWidget({required Widget child}) {
    return CupertinoRefreshPage(
      onRefresh: null,
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
      _searchHistoryBloc.add(
        SearchHistoryFetched(
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

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: CupertinoSearchTextField(
        controller: _textController,
        focusNode: _focusNode,
        autofocus: true,
        autocorrect: false,
        onSuffixTap: isNotEmpty(_textController.text)
            ? () {
                setState(() {
                  _textController.text = '';
                  _hasContent = false;
                  _firstPageLoad = true;
                });
                _searchHistoryBloc.add(SearchHistoryClear());
                FocusScope.of(context).requestFocus(_focusNode);
              }
            : null,
        onChanged: (value) {
          if (!_hasContent) {
            setState(() {
              _hasContent = true;
            });
          }

          if (_hasContent && value == '') {
            setState(() {
              _hasContent = false;
            });
          }
        },
        onSubmitted: (value) {
          if (isNotBlank(value)) {
            setState(() {
              _filterRefresh = true;
            });

            _searchHistoryBloc.add(
              SearchHistoryFetched(
                server: _server,
                userId: _userId,
                movieMediaType: _movieMediaType,
                episodeMediaType: _episodeMediaType,
                trackMediaType: _trackMediaType,
                liveMediaType: _liveMediaType,
                directPlayDecision: _directPlayDecision,
                directStreamDecision: _directStreamDecision,
                transcodeDecision: _transcodeDecision,
                search: value,
                freshFetch: true,
                settingsBloc: _settingsBloc,
              ),
            );
          }
        },
      ),
    );
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
                child: HistoryActionsActionSheet(
                  userId: _userId,
                  filterApplied: _filterOptionSelected(),
                ),
              ),
            );

            if (result == 'user') {
              int newUserId = await showCupertinoSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<UsersBloc>(),
                  child: HistoryUserFilterIosBottomSheet(
                    initialValue: _userId,
                  ),
                ),
              );

              if (newUserId != _userId) {
                setState(() {
                  _userId = newUserId;

                  if (!_firstPageLoad) {
                    _filterRefresh = true;

                    _searchHistoryBloc.add(
                      SearchHistoryFetched(
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
                });
              }
            }
            if (result == 'filter') {
              final bool? filterUnchanged = await showCupertinoSheet(
                context: context,
                builder: (_) => HistoryFilterIosBottomSheet(
                  filterMap: _filterMap,
                ),
              );

              if (filterUnchanged == false) {
                setState(() {
                  _movieMediaType = _filterMap['movie'] ?? true;
                  _episodeMediaType = _filterMap['episode'] ?? true;
                  _trackMediaType = _filterMap['track'] ?? true;
                  _liveMediaType = _filterMap['live'] ?? true;
                  _directPlayDecision = _filterMap['directPlay'] ?? true;
                  _directStreamDecision = _filterMap['directStream'] ?? true;
                  _transcodeDecision = _filterMap['transcode'] ?? true;
                });

                if (!_firstPageLoad) {
                  setState(() {
                    _filterRefresh = true;
                  });

                  _searchHistoryBloc.add(
                    SearchHistoryFetched(
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
              });

              if (!_firstPageLoad) {
                setState(() {
                  _filterRefresh = true;
                });

                _searchHistoryBloc.add(
                  SearchHistoryFetched(
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
          },
        ),
      ],
    );
  }
}
