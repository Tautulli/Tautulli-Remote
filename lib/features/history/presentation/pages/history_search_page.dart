import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/presentation/bloc/users_bloc.dart';
import '../bloc/search_history_bloc.dart';
import '../widgets/history_card.dart';

class HistorySearchPage extends StatelessWidget {
  const HistorySearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchHistoryBloc>(),
      child: const HistorySearchView(),
    );
  }
}

class HistorySearchView extends StatefulWidget {
  const HistorySearchView({
    super.key,
  });

  @override
  State<HistorySearchView> createState() => _HistorySearchViewState();
}

class _HistorySearchViewState extends State<HistorySearchView> {
  final TextEditingController _controller = TextEditingController();
  bool hasContent = false;

  final _scrollController = ScrollController();
  late SearchHistoryBloc _searchHistoryBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;
  int? _userId;
  bool _movieMediaType = false;
  bool _episodeMediaType = false;
  bool _trackMediaType = false;
  bool _liveMediaType = false;
  bool _directPlayDecision = false;
  bool _directStreamDecision = false;
  bool _transcodeDecision = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _searchHistoryBloc = context.read<SearchHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            settingsState as SettingsSuccess;

            return TextField(
              controller: _controller,
              autofocus: true,
              cursorColor: Theme.of(context).colorScheme.tertiary,
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.subtitle2!.color!,
                    width: 2,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.subtitle2!.color!,
                    width: 2,
                  ),
                ),
                hintText: LocaleKeys.search_history_title.tr(),
                suffixIcon: SizedBox(
                  width: 20,
                  height: 20,
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.solidCircleXmark,
                      color: isNotEmpty(_controller.text)
                          ? Theme.of(context).textTheme.subtitle2!.color!
                          : Colors.transparent,
                      size: 20,
                    ),
                    onPressed: isNotEmpty(_controller.text)
                        ? () {
                            setState(() {
                              _controller.text = '';
                              hasContent = false;
                            });
                            _searchHistoryBloc.add(SearchHistoryClear());
                          }
                        : null,
                  ),
                ),
              ),
              onChanged: (value) {
                if (!hasContent) {
                  setState(() {
                    hasContent = true;
                  });
                }

                if (hasContent && value == '') {
                  setState(() {
                    hasContent = false;
                  });
                }
              },
              onSubmitted: (value) {
                if (isNotBlank(value)) {
                  context.read<SearchHistoryBloc>().add(
                        SearchHistoryFetched(
                          tautulliId:
                              settingsState.appSettings.activeServer.tautulliId,
                          search: value,
                          movieMediaType: _movieMediaType,
                          episodeMediaType: _episodeMediaType,
                          trackMediaType: _trackMediaType,
                          liveMediaType: _liveMediaType,
                          directPlayDecision: _directPlayDecision,
                          directStreamDecision: _directStreamDecision,
                          transcodeDecision: _transcodeDecision,
                          freshFetch: true,
                          settingsBloc: context.read<SettingsBloc>(),
                        ),
                      );
                }
              },
            );
          },
        ),
        actions: _appBarActions(),
      ),
      body: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
        builder: (context, searchState) {
          return PageBody(
            loading: searchState.status == BlocStatus.inProgress,
            child: Builder(
              builder: (context) {
                if (searchState.history.isEmpty) {
                  if (searchState.status == BlocStatus.failure) {
                    return StatusPage(
                      scrollable: true,
                      message: searchState.message ?? '',
                      suggestion: searchState.suggestion ?? '',
                    );
                  }
                  if (searchState.status == BlocStatus.success) {
                    return StatusPage(
                      scrollable: true,
                      message: LocaleKeys.history_empty_message.tr(),
                    );
                  }
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: searchState.hasReachedMax ||
                          searchState.status == BlocStatus.initial ||
                          searchState.status == BlocStatus.inProgress
                      ? searchState.history.length
                      : searchState.history.length + 1,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    if (index >= searchState.history.length) {
                      return BottomLoader(
                        status: searchState.status,
                        failure: searchState.failure,
                        message: searchState.message,
                        suggestion: searchState.suggestion,
                        onTap: () {
                          _searchHistoryBloc.add(
                            SearchHistoryFetched(
                              tautulliId: _tautulliId,
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

                    final history = searchState.history[index];

                    return HistoryCard(history: history);
                  },
                );
              },
            ),
          );
        },
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
      _searchHistoryBloc.add(
        SearchHistoryFetched(
          tautulliId: _tautulliId,
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
      BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: PopupMenuButton(
                  enabled: state.status == BlocStatus.success,
                  icon: FaIcon(
                    state.status == BlocStatus.failure
                        ? FontAwesomeIcons.userSlash
                        : FontAwesomeIcons.solidUser,
                    color: (_userId != -1 && _userId != null)
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                    size: 20,
                  ),
                  tooltip: LocaleKeys.select_user_title.tr(),
                  onSelected: (value) {
                    setState(() {
                      _userId = value as int;
                    });

                    if (isNotBlank(_controller.text)) {
                      _searchHistoryBloc.add(
                        SearchHistoryFetched(
                          tautulliId: _tautulliId,
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
                  itemBuilder: (context) {
                    return state.users
                        .map(
                          (user) => PopupMenuItem(
                            value: user.userId,
                            child: BlocBuilder<SettingsBloc, SettingsState>(
                              builder: (context, state) {
                                state as SettingsSuccess;

                                return Text(
                                  state.appSettings.maskSensitiveInfo
                                      ? LocaleKeys.hidden_message.tr()
                                      : user.friendlyName ?? '',
                                  style: TextStyle(
                                    color: _userId == user.userId!
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : null,
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
                const Positioned(
                  bottom: 12,
                  right: 10,
                  child: SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
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
          return Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: DividerThemeData(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            child: PopupMenuButton(
              icon: FaIcon(
                FontAwesomeIcons.filter,
                color: _filterOptionSelected()
                    ? Theme.of(context).colorScheme.secondary
                    : null,
                size: 20,
              ),
              tooltip: LocaleKeys.filter_history_title.tr(),
              itemBuilder: _filterOptions,
            ),
          );
        },
      ),
    ];
  }

  bool _filterOptionSelected() {
    return _movieMediaType ||
        _episodeMediaType ||
        _trackMediaType ||
        _liveMediaType ||
        _directPlayDecision ||
        _directStreamDecision ||
        _transcodeDecision;
  }

  List<PopupMenuEntry<Object?>> _filterOptions(BuildContext context) {
    ValueNotifier<bool> movieMediaTypeNotifier = ValueNotifier(_movieMediaType);
    ValueNotifier<bool> episodeMediaTypeNotifier = ValueNotifier(
      _episodeMediaType,
    );
    ValueNotifier<bool> trackMediaTypeNotifier = ValueNotifier(_trackMediaType);
    ValueNotifier<bool> liveMediaTypeNotifier = ValueNotifier(_liveMediaType);
    ValueNotifier<bool> directPlayDecisionNotifier = ValueNotifier(
      _directPlayDecision,
    );
    ValueNotifier<bool> directStreamDecisionNotifier = ValueNotifier(
      _directStreamDecision,
    );
    ValueNotifier<bool> transcodeDecisionNotifier = ValueNotifier(
      _transcodeDecision,
    );

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
    valueNotifier.value = value;
    if (isNotBlank(_controller.text)) {
      _searchHistoryBloc.add(
        SearchHistoryFetched(
          tautulliId: _tautulliId,
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
