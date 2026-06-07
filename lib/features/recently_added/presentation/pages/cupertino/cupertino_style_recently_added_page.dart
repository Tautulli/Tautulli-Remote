import 'dart:async';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/utilities/cast.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_bottom_loader.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/recently_added_bloc.dart';
import '../../widgets/cupertino/cupertino_style_recently_added_filter_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_recently_added_card.dart';

class CupertinoStyleRecentlyAddedPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const CupertinoStyleRecentlyAddedPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
    this.refreshOnLoad = false,
  });

  static const routeName = '/recent';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RecentlyAddedBloc>(),
      child: CupertinoStyleRecentlyAddedView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
        refreshOnLoad: refreshOnLoad,
      ),
    );
  }
}

class CupertinoStyleRecentlyAddedView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;
  final bool refreshOnLoad;

  const CupertinoStyleRecentlyAddedView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
    required this.refreshOnLoad,
  });

  @override
  State<CupertinoStyleRecentlyAddedView> createState() => _CupertinoStyleRecentlyAddedViewState();
}

class _CupertinoStyleRecentlyAddedViewState extends State<CupertinoStyleRecentlyAddedView> {
  final _scrollController = ScrollController();
  late RecentlyAddedBloc _recentlyAddedBloc;
  late SettingsBloc _settingsBloc;
  late ServerModel _server;
  MediaType? _mediaType;
  late Completer<void> _refreshCompleter;
  bool _filterRefresh = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _recentlyAddedBloc = context.read<RecentlyAddedBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;

    _mediaType = settingsState.appSettings.recentlyAddedFilter == 'all'
        ? null
        : Cast.castStringToMediaType(
            settingsState.appSettings.recentlyAddedFilter,
          );

    _refreshCompleter = Completer<void>();

    _recentlyAddedBloc.add(
      RecentlyAddedFetched(
        server: _server,
        mediaType: _mediaType,
        freshFetch: widget.refreshOnLoad,
        settingsBloc: _settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
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

          _filterRefresh = true;

          _recentlyAddedBloc.add(
            RecentlyAddedFetched(
              server: _server,
              mediaType: _mediaType,
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
        middle: const Text(LocaleKeys.recently_added_title).tr(),
        child: BlocConsumer<RecentlyAddedBloc, RecentlyAddedState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              _filterRefresh = false;
            }
          },
          builder: (context, state) {
            if (state.recentlyAdded.isEmpty) {
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
                    message: LocaleKeys.recently_added_empty_message.tr(),
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
                  _recentlyAddedBloc.add(
                    RecentlyAddedFetched(
                      server: _server,
                      mediaType: _mediaType,
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

                        if (itemIndex >= state.recentlyAdded.length) {
                          return CupertinoStyleBottomLoader(
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

                        if (index.isEven) {
                          final recentlyAdded = state.recentlyAdded[itemIndex];

                          return CupertinoStyleRecentlyAddedCard(
                            server: _server,
                            recentlyAdded: recentlyAdded,
                          );
                        } else {
                          return const Gap(8);
                        }
                      },
                      childCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? (state.recentlyAdded.length * 2) - 1
                          : (state.recentlyAdded.length * 2) + 1,
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
        _recentlyAddedBloc.add(
          RecentlyAddedFetched(
            server: _server,
            mediaType: _mediaType,
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

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Badge(
            showBadge: _mediaType != null,
            position: BadgePosition.bottomEnd(bottom: -3, end: -3),
            badgeStyle: BadgeStyle(
              badgeColor: CupertinoTheme.of(context).primaryColor,
              borderSide: BorderSide(
                width: 2,
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
              ),
            ),
            child: Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              color: ThemeHelper.cupertinoNavigationBarItemColor(),
            ),
          ),
          onPressed: () async {
            MediaType? mediaType = await showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoStyleRecentlyAddedFilterBottomSheet(
                mediaType: _mediaType,
              ),
            );

            if (mediaType != _mediaType) {
              _mediaType = mediaType;

              if (mediaType == null) {
                _settingsBloc.add(
                  const SettingsUpdateRecentlyAddedFilter('all'),
                );
              } else {
                _settingsBloc.add(
                  SettingsUpdateRecentlyAddedFilter(Cast.castToString(_mediaType) ?? 'all'),
                );
              }

              _filterRefresh = true;

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
        ),
      ],
    );
  }
}
