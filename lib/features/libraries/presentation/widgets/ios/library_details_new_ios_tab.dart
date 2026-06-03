import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../../recently_added/presentation/widgets/ios/recently_added_ios_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';

class LibraryDetailsNewIosTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsNewIosTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsNewIosTab> createState() => _LibraryDetailsNewIosTabState();
}

class _LibraryDetailsNewIosTabState extends State<LibraryDetailsNewIosTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          context.read<LibraryRecentlyAddedBloc>().add(
            LibraryRecentlyAddedFetched(
              tautulliId: widget.server.tautulliId,
              sectionId: widget.libraryTableModel.sectionId!,
              settingsBloc: _settingsBloc,
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
                      child: StatusIosPage(
                        message: state.message ?? 'Unknown failure.',
                        suggestion: state.suggestion,
                      ),
                    );
                  }

                  if (state.recentlyAdded.isEmpty) {
                    return SliverFillRemaining(
                      child: StatusIosPage(
                        message: LocaleKeys.history_empty_message.tr(),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: state.recentlyAdded.length,
                    itemBuilder: (context, index) {
                      final recentlyAdded = state.recentlyAdded[index];

                      return RecentlyAddedIosCard(
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
