import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/material/material_style_bottom_loader.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/user_history_bloc.dart';
import '../../../../history/presentation/widgets/material/material_style_history_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';

class MaterialStyleUserDetailsHistoryTab extends StatefulWidget {
  final ServerModel server;
  final UserModel user;

  const MaterialStyleUserDetailsHistoryTab({
    super.key,
    required this.server,
    required this.user,
  });

  @override
  State<MaterialStyleUserDetailsHistoryTab> createState() => _MaterialStyleUserDetailsHistoryTabState();
}

class _MaterialStyleUserDetailsHistoryTabState extends State<MaterialStyleUserDetailsHistoryTab> {
  ScrollController? _scrollController;
  late UserHistoryBloc _userHistoryBloc;

  @override
  void initState() {
    super.initState();
    _userHistoryBloc = context.read<UserHistoryBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UserHistoryBloc, UserHistoryState>(
      builder: (context, state) {
        return MaterialStyleRefreshIndicator(
          onRefresh: () {
            _userHistoryBloc.add(
              UserHistoryFetched(
                server: widget.server,
                userId: widget.user.userId!,
                freshFetch: true,
              ),
            );

            return Future.value();
          },
          child: MaterialStylePageBody(
            loading: state.status == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.status == BlocStatus.failure) {
                  return MaterialStyleStatusPage(
                    scrollable: true,
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                if (state.history.isEmpty) {
                  return MaterialStyleStatusPage(
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
                      return MaterialStyleBottomLoader(
                        status: state.status,
                        failure: state.failure,
                        message: state.message,
                        suggestion: state.suggestion,
                        onTap: () {
                          _userHistoryBloc.add(
                            UserHistoryFetched(
                              server: widget.server,
                              userId: widget.user.userId!,
                            ),
                          );
                        },
                      );
                    }

                    final history = state.history[index];

                    return MaterialStyleHistoryCard(
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
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _userHistoryBloc.add(
        UserHistoryFetched(
          server: widget.server,
          userId: widget.user.userId!,
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
