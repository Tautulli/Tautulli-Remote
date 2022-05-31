import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

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

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
      child: const HistoryView(),
    );
  }
}

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final _scrollController = ScrollController();
  late HistoryBloc _historyBloc;
  late UsersBloc _usersBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;
  late int? _userId;
  late String _mediaType;
  late String _transcodeDecision;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _historyBloc = context.read<HistoryBloc>();
    _usersBloc = context.read<UsersBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;

    _userId = _historyBloc.state.userId ?? -1;
    _mediaType = _historyBloc.state.mediaType;
    _transcodeDecision = _historyBloc.state.transcodeDecision;

    _historyBloc.add(
      HistoryFetched(
        tautulliId: _tautulliId,
        userId: _userId,
        mediaType: _mediaType,
        transcodeDecision: _transcodeDecision,
        settingsBloc: _settingsBloc,
      ),
    );

    _usersBloc.add(
      UsersFetched(
        tautulliId: _tautulliId,
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
          _userId = null;
          _mediaType = 'all';
          _transcodeDecision = 'all';

          _historyBloc.add(
            HistoryFetched(
              tautulliId: _tautulliId,
              userId: _userId,
              mediaType: _mediaType,
              transcodeDecision: _transcodeDecision,
              settingsBloc: _settingsBloc,
            ),
          );
          _usersBloc.add(
            UsersFetched(
              tautulliId: _tautulliId,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.history_title).tr(),
        actions: _appBarActions(),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return PageBody(
              loading:
                  state.status == BlocStatus.initial && !state.hasReachedMax,
              child: ThemedRefreshIndicator(
                onRefresh: () {
                  _historyBloc.add(
                    HistoryFetched(
                      tautulliId: _tautulliId,
                      userId: _userId,
                      mediaType: _mediaType,
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
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax ||
                              state.status == BlocStatus.initial
                          ? state.history.length
                          : state.history.length + 1,
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
                                  tautulliId: _tautulliId,
                                  userId: _userId,
                                  mediaType: _mediaType,
                                  transcodeDecision: _transcodeDecision,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        final history = state.history[index];

                        return HistoryCard(history: history);
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
          tautulliId: _tautulliId,
          userId: _userId,
          mediaType: _mediaType,
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
                  ),
                  tooltip: LocaleKeys.select_user_title.tr(),
                  onSelected: (value) {
                    setState(() {
                      _userId = value as int;
                    });

                    _historyBloc.add(
                      HistoryFetched(
                        tautulliId: _tautulliId,
                        userId: _userId,
                        mediaType: _mediaType,
                        transcodeDecision: _transcodeDecision,
                        freshFetch: true,
                        settingsBloc: _settingsBloc,
                      ),
                    );
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
                color: _mediaType != 'all' || _transcodeDecision != 'all'
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              tooltip: LocaleKeys.filter_history_title.tr(),
              itemBuilder: (context) {
                ValueNotifier<String> selectedMediaType = ValueNotifier(
                  _mediaType,
                );
                ValueNotifier<String> selectedTranscodeType =
                    ValueNotifier(_transcodeDecision);

                List mediaTypes = [
                  'all',
                  'movie',
                  'episode',
                  'track',
                  'live',
                ];
                List transcodeTypes = [
                  'all',
                  'direct play',
                  'copy',
                  'transcode',
                ];

                return List.generate(
                  10,
                  (index) {
                    if (index == 5) {
                      return const PopupMenuDivider();
                    } else if (index < 5) {
                      return PopupMenuItem(
                        padding: const EdgeInsets.all(0),
                        child: AnimatedBuilder(
                          animation: selectedMediaType,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              _mediaTypeToTitle(mediaTypes[index]),
                            ),
                          ),
                          builder: (context, child) {
                            return RadioListTile<String>(
                              value: mediaTypes[index],
                              groupValue: selectedMediaType.value,
                              onChanged: (value) {
                                if (value != null && _mediaType != value) {
                                  selectedMediaType.value = value;
                                  setState(() {
                                    _mediaType = value;
                                  });
                                  _historyBloc.add(
                                    HistoryFetched(
                                      tautulliId: _tautulliId,
                                      userId: _userId,
                                      mediaType: _mediaType,
                                      transcodeDecision: _transcodeDecision,
                                      freshFetch: true,
                                      settingsBloc: _settingsBloc,
                                    ),
                                  );
                                }
                              },
                              title: child,
                            );
                          },
                        ),
                      );
                    } else {
                      return PopupMenuItem(
                        padding: const EdgeInsets.all(0),
                        child: AnimatedBuilder(
                          animation: selectedTranscodeType,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              _transcodeDecisionToTitle(
                                transcodeTypes[index - 6],
                              ),
                            ),
                          ),
                          builder: (context, child) {
                            return RadioListTile<String>(
                              value: transcodeTypes[index - 6],
                              groupValue: selectedTranscodeType.value,
                              onChanged: (value) {
                                if (value != null &&
                                    _transcodeDecision != value) {
                                  selectedTranscodeType.value = value;
                                  setState(() {
                                    _transcodeDecision = value;
                                  });
                                  _historyBloc.add(
                                    HistoryFetched(
                                      tautulliId: _tautulliId,
                                      userId: _userId,
                                      mediaType: _mediaType,
                                      transcodeDecision: _transcodeDecision,
                                      freshFetch: true,
                                      settingsBloc: _settingsBloc,
                                    ),
                                  );
                                }
                              },
                              title: child,
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    ];
  }
}

String _mediaTypeToTitle(String mediaType) {
  switch (mediaType) {
    case ('all'):
      return LocaleKeys.all_title.tr();
    case ('movie'):
      return LocaleKeys.movies_title.tr();
    case ('episode'):
      return LocaleKeys.tv_shows_title.tr();
    case ('track'):
      return LocaleKeys.music_title.tr();
    case ('other_video'):
      return LocaleKeys.videos_title.tr();
    case ('live'):
      return LocaleKeys.live_tv_title.tr();
    default:
      return '';
  }
}

String _transcodeDecisionToTitle(String decision) {
  switch (decision) {
    case ('all'):
      return LocaleKeys.all_title.tr();
    case ('direct play'):
      return LocaleKeys.direct_play_title.tr();
    case ('copy'):
      return LocaleKeys.direct_stream_title.tr();
    case ('transcode'):
      return LocaleKeys.transcode_title.tr();
    default:
      return '';
  }
}
