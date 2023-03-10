import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../history/presentation/bloc/library_history_bloc.dart';
import '../../../history/presentation/widgets/history_card.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';

class LibraryDetailsHistoryTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsHistoryTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsHistoryTab> createState() => _LibraryDetailsHistoryTabState();
}

class _LibraryDetailsHistoryTabState extends State<LibraryDetailsHistoryTab> {
  ScrollController? _scrollController;
  late LibraryHistoryBloc _libraryHistoryBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _libraryHistoryBloc = context.read<LibraryHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // Only attach scrollController if it's currently null
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);
    }

    return BlocBuilder<LibraryHistoryBloc, LibraryHistoryState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            _libraryHistoryBloc.add(
              LibraryHistoryFetched(
                server: widget.server,
                sectionId: widget.libraryTableModel.sectionId!,
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
                          _libraryHistoryBloc.add(
                            LibraryHistoryFetched(
                              server: widget.server,
                              sectionId: widget.libraryTableModel.sectionId!,
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
                      viewMediaEnabled: history.live != true,
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
      _libraryHistoryBloc.add(
        LibraryHistoryFetched(
          server: widget.server,
          sectionId: widget.libraryTableModel.sectionId!,
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
