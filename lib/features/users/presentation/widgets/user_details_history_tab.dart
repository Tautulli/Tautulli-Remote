import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../history/presentation/bloc/user_history_bloc.dart';
import '../../../history/presentation/widgets/history_card.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';

class UserDetailsHistoryTab extends StatefulWidget {
  final ServerModel server;
  final UserModel user;

  const UserDetailsHistoryTab({
    super.key,
    required this.server,
    required this.user,
  });

  @override
  State<UserDetailsHistoryTab> createState() => _UserDetailsHistoryTabState();
}

class _UserDetailsHistoryTabState extends State<UserDetailsHistoryTab> {
  ScrollController? _scrollController;
  late UserHistoryBloc _userHistoryBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _userHistoryBloc = context.read<UserHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // Only attach scrollController if it's currently null
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);
    }

    return BlocBuilder<UserHistoryBloc, UserHistoryState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            _userHistoryBloc.add(
              UserHistoryFetched(
                server: widget.server,
                userId: widget.user.userId!,
                settingsBloc: _settingsBloc,
                freshFetch: true,
              ),
            );

            return Future.value();
          },
          child: PageBody(
            loading: state.status == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.status == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                if (state.history.isEmpty) {
                  return StatusPage(
                    scrollable: true,
                    message: LocaleKeys.history_empty_message.tr(),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.hasReachedMax || state.status == BlocStatus.initial
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

                    final history = state.history[index];

                    return HistoryCard(
                      server: widget.server,
                      history: history,
                      showUser: false,
                      viewUserEnabled: false,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_onScroll);
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
    if (!_scrollController!.hasClients) return false;
    final maxScroll = _scrollController!.position.maxScrollExtent;
    final currentScroll = _scrollController!.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}
