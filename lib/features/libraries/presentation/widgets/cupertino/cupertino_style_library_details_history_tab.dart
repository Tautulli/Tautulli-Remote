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
import '../../../../history/presentation/bloc/library_history_bloc.dart';
import '../../../../history/presentation/widgets/cupertino/cupertino_style_history_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';

class CupertinoStyleLibraryDetailsHistoryTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const CupertinoStyleLibraryDetailsHistoryTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<CupertinoStyleLibraryDetailsHistoryTab> createState() => _CupertinoStyleLibraryDetailsHistoryTabState();
}

class _CupertinoStyleLibraryDetailsHistoryTabState extends State<CupertinoStyleLibraryDetailsHistoryTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late LibraryHistoryBloc _libraryHistoryBloc;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _libraryHistoryBloc = context.read<LibraryHistoryBloc>();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoStyleRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          _libraryHistoryBloc.add(
            LibraryHistoryFetched(
              server: widget.server,
              sectionId: widget.libraryTableModel.sectionId!,
              freshFetch: true,
            ),
          );

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<LibraryHistoryBloc, LibraryHistoryState>(
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
                        message: state.message ?? LocaleKeys.error_message_generic.tr(),
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
                              _libraryHistoryBloc.add(
                                LibraryHistoryFetched(
                                  server: widget.server,
                                  sectionId: widget.libraryTableModel.sectionId!,
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
    if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _libraryHistoryBloc.add(
        LibraryHistoryFetched(
          server: widget.server,
          sectionId: widget.libraryTableModel.sectionId!,
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
