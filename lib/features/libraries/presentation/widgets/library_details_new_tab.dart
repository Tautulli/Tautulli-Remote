import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../recently_added/presentation/widgets/recently_added_card.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';

class LibraryDetailsNewTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsNewTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsNewTab> createState() => _LibraryDetailsNewTabState();
}

class _LibraryDetailsNewTabState extends State<LibraryDetailsNewTab> {
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryRecentlyAddedBloc, LibraryRecentlyAddedState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            context.read<LibraryRecentlyAddedBloc>().add(
                  LibraryRecentlyAddedFetched(
                    tautulliId: widget.server.tautulliId,
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: state.recentlyAdded.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final recentlyAdded = state.recentlyAdded[index];

                    return RecentlyAddedCard(
                      server: widget.server,
                      recentlyAdded: recentlyAdded,
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
}
