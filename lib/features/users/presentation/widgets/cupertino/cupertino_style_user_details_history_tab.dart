import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_bottom_loader.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/user_history_bloc.dart';
import '../../../../history/presentation/widgets/cupertino/cupertino_style_history_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';

class CupertinoStyleUserDetailsHistoryTab extends StatefulWidget {
  final ServerModel server;
  final UserModel user;

  const CupertinoStyleUserDetailsHistoryTab({
    super.key,
    required this.server,
    required this.user,
  });

  @override
  State<CupertinoStyleUserDetailsHistoryTab> createState() => _CupertinoStyleUserDetailsHistoryTabState();
}

class _CupertinoStyleUserDetailsHistoryTabState extends State<CupertinoStyleUserDetailsHistoryTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late UserHistoryBloc _userHistoryBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _userHistoryBloc = context.read<UserHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoStyleRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          _userHistoryBloc.add(
            UserHistoryFetched(
              server: widget.server,
              userId: widget.user.userId!,
              settingsBloc: _settingsBloc,
              freshFetch: true,
            ),
          );

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<UserHistoryBloc, UserHistoryState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            return SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
              sliver: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  if (state.status == BlocStatus.initial && state.history.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }

                  if (state.status == BlocStatus.failure) {
                    return SliverFillRemaining(
                      child: CupertinoStyleStatusPage(
                        message: state.message ?? 'Unknown failure.',
                        suggestion: state.suggestion,
                      ),
                    );
                  }

                  if (state.history.isEmpty) {
                    return SliverFillRemaining(
                      child: CupertinoStyleStatusPage(
                        message: LocaleKeys.history_empty_message.tr(),
                      ),
                    );
                  }

                  return SliverList(
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
                              _userHistoryBloc.add(
                                UserHistoryFetched(
                                  server: widget.server,
                                  userId: widget.user.userId!,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        if (index.isEven) {
                          final history = state.history[itemIndex];

                          return CupertinoStyleHistoryCard(
                            server: widget.server,
                            history: history,
                            showUser: false,
                            viewUserEnabled: false,
                          );
                        } else {
                          return const Gap(8);
                        }
                      },
                      childCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? (state.history.length * 2) - 1
                          : (state.history.length * 2) + 1,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _userHistoryBloc.add(
        UserHistoryFetched(
          server: widget.server,
          userId: widget.user.userId!,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}
