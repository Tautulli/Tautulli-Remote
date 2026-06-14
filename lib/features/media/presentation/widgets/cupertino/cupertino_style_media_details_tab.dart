import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/metadata_bloc.dart';
import '../base/media_details_tab_details.dart';
import 'cupertino_style_media_details_tab_summary.dart';

class CupertinoStyleMediaDetailsTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;

  const CupertinoStyleMediaDetailsTab({
    super.key,
    required this.server,
    required this.ratingKey,
  });

  @override
  State<CupertinoStyleMediaDetailsTab> createState() => _CupertinoStyleMediaDetailsTabState();
}

class _CupertinoStyleMediaDetailsTabState extends State<CupertinoStyleMediaDetailsTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
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
          context.read<MetadataBloc>().add(
            MetadataFetched(
              server: widget.server,
              ratingKey: widget.ratingKey,
              freshFetch: true,
              settingsBloc: _settingsBloc,
            ),
          );

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<MetadataBloc, MetadataState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            return BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.status == BlocStatus.initial && state.metadata == null) {
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

                return SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      if (isNotBlank(state.metadata?.tagline) || isNotBlank(state.metadata?.summary))
                        CupertinoStyleMediaDetailsTabSummary(metadata: state.metadata),
                      const Gap(8),
                      MediaDetailsTabDetails(
                        metadata: state.metadata,
                        titleColor: CupertinoColors.systemGrey2,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
