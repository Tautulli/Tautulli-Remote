import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../../recently_added/presentation/widgets/material/material_style_recently_added_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';

class MaterialStyleLibraryDetailsNewTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const MaterialStyleLibraryDetailsNewTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<MaterialStyleLibraryDetailsNewTab> createState() => _MaterialStyleLibraryDetailsNewTabState();
}

class _MaterialStyleLibraryDetailsNewTabState extends State<MaterialStyleLibraryDetailsNewTab> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryRecentlyAddedBloc, LibraryRecentlyAddedState>(
      builder: (context, state) {
        return MaterialStyleRefreshIndicator(
          onRefresh: () {
            context.read<LibraryRecentlyAddedBloc>().add(
              LibraryRecentlyAddedFetched(
                tautulliId: widget.server.tautulliId,
                sectionId: widget.libraryTableModel.sectionId!,
                freshFetch: true,
              ),
            );

            return Future.value();
          },
          child: MaterialStylePageBody(
            loading: state.status == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                if (state.recentlyAdded.isEmpty) {
                  if (state.status == BlocStatus.failure) {
                    return MaterialStyleStatusPage(
                      scrollable: true,
                      message: state.message ?? '',
                      suggestion: state.suggestion ?? '',
                    );
                  }
                  if (state.status == BlocStatus.success) {
                    return MaterialStyleStatusPage(
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

                    return MaterialStyleRecentlyAddedCard(
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
