import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/recently_added_bloc.dart';
import '../widgets/recently_added_card.dart';

class RecentlyAddedPage extends StatelessWidget {
  const RecentlyAddedPage({super.key});

  static const routeName = '/recent';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RecentlyAddedBloc>(),
      child: const RecentlyAddedView(),
    );
  }
}

class RecentlyAddedView extends StatefulWidget {
  const RecentlyAddedView({super.key});

  @override
  State<RecentlyAddedView> createState() => _RecentlyAddedViewState();
}

class _RecentlyAddedViewState extends State<RecentlyAddedView> {
  final _scrollController = ScrollController();
  late RecentlyAddedBloc _recentlyAddedBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;
  MediaType? _mediaType;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _recentlyAddedBloc = context.read<RecentlyAddedBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    _mediaType = _recentlyAddedBloc.state.mediaType;

    _recentlyAddedBloc.add(
      RecentlyAddedFetched(
        server: _server,
        mediaType: _mediaType,
        settingsBloc: _settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;
          _mediaType = null;

          _recentlyAddedBloc.add(
            RecentlyAddedFetched(
              server: _server,
              mediaType: _mediaType,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.recently_added_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: BlocBuilder<RecentlyAddedBloc, RecentlyAddedState>(
          builder: (context, state) {
            return PageBody(
              loading:
                  state.status == BlocStatus.initial && !state.hasReachedMax,
              child: ThemedRefreshIndicator(
                onRefresh: () {
                  _recentlyAddedBloc.add(
                    RecentlyAddedFetched(
                      server: _server,
                      mediaType: _mediaType,
                      freshFetch: true,
                      settingsBloc: _settingsBloc,
                    ),
                  );

                  return Future.value(null);
                },
                child: Builder(
                  builder: (context) {
                    if (state.recentlyAdded.isEmpty) {
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
                          message: LocaleKeys.recently_added_empty_message.tr(),
                        );
                      }
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: state.hasReachedMax ||
                              state.status == BlocStatus.initial
                          ? state.recentlyAdded.length
                          : state.recentlyAdded.length + 1,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        if (index >= state.recentlyAdded.length) {
                          return BottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              _recentlyAddedBloc.add(
                                RecentlyAddedFetched(
                                  server: _server,
                                  mediaType: _mediaType,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        final recentlyAdded = state.recentlyAdded[index];

                        return RecentlyAddedCard(
                          server: _server,
                          recentlyAdded: recentlyAdded,
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
      _recentlyAddedBloc.add(
        RecentlyAddedFetched(
          server: _server,
          mediaType: _mediaType,
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
      PopupMenuButton(
        color: Theme.of(context).colorScheme.primary,
        tooltip: LocaleKeys.filter_recently_added_title.tr(),
        // Use BlocBuilder to update the state of the icon when server is
        // changed without closing the inner drawer.
        icon: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return FaIcon(
              FontAwesomeIcons.filter,
              color: _mediaType != null
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
              size: 20,
            );
          },
        ),
        onSelected: (String? value) {
          bool changed = false;

          setState(() {
            if (value == 'all' && _mediaType != null) {
              _mediaType = null;
              changed = true;
            }
            if (value == 'movie' && _mediaType != MediaType.movie) {
              _mediaType = MediaType.movie;
              changed = true;
            }
            if (value == 'show' && _mediaType != MediaType.show) {
              _mediaType = MediaType.show;
              changed = true;
            }
            if (value == 'artist' && _mediaType != MediaType.artist) {
              _mediaType = MediaType.artist;
              changed = true;
            }
            if (value == 'other' && _mediaType != MediaType.otherVideo) {
              _mediaType = MediaType.otherVideo;
              changed = true;
            }
          });

          if (changed) {
            _recentlyAddedBloc.add(
              RecentlyAddedFetched(
                server: _server,
                mediaType: _mediaType,
                freshFetch: true,
                settingsBloc: _settingsBloc,
              ),
            );
          }
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 'all',
              child: Text(
                'All',
                style: TextStyle(
                  color: _mediaType == null
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'movie',
              child: Text(
                'Movies',
                style: TextStyle(
                  color: _mediaType == MediaType.movie
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'show',
              child: Text(
                'TV Shows',
                style: TextStyle(
                  color: _mediaType == MediaType.show
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'artist',
              child: Text(
                'Music',
                style: TextStyle(
                  color: _mediaType == MediaType.artist
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'other',
              child: Text(
                'Videos',
                style: TextStyle(
                  color: _mediaType == MediaType.otherVideo
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
            ),
          ];
        },
      ),
    ];
  }
}
