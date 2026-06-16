import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../../recently_added/presentation/widgets/cupertino/cupertino_style_recently_added_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';

class CupertinoStyleLibraryDetailsNewTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const CupertinoStyleLibraryDetailsNewTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<CupertinoStyleLibraryDetailsNewTab> createState() => _CupertinoStyleLibraryDetailsNewTabState();
}

class _CupertinoStyleLibraryDetailsNewTabState extends State<CupertinoStyleLibraryDetailsNewTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoStyleRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          context.read<LibraryRecentlyAddedBloc>().add(
            LibraryRecentlyAddedFetched(
              tautulliId: widget.server.tautulliId,
              sectionId: widget.libraryTableModel.sectionId!,
              freshFetch: true,
            ),
          );

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<LibraryRecentlyAddedBloc, LibraryRecentlyAddedState>(
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

                  if (state.status == BlocStatus.initial && state.recentlyAdded.isEmpty) {
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

                  if (state.recentlyAdded.isEmpty) {
                    return SliverFillRemaining(
                      child: CupertinoStyleStatusPage(
                        message: LocaleKeys.recently_added_empty_message.tr(),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: state.recentlyAdded.length,
                    itemBuilder: (context, index) {
                      final recentlyAdded = state.recentlyAdded[index];

                      return CupertinoStyleRecentlyAddedCard(
                        server: widget.server,
                        recentlyAdded: recentlyAdded,
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(8),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
