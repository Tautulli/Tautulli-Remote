import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/metadata_bloc.dart';
import 'media_details_ios_tab_details.dart';
import 'media_details_ios_tab_summary.dart';

class MediaDetailsIosTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;

  const MediaDetailsIosTab({
    super.key,
    required this.server,
    required this.ratingKey,
  });

  @override
  State<MediaDetailsIosTab> createState() => _MediaDetailsIosTabState();
}

class _MediaDetailsIosTabState extends State<MediaDetailsIosTab> {
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
            return SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
              sliver: BlocBuilder<SettingsBloc, SettingsState>(
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
                      child: StatusIosPage(
                        message: state.message ?? 'Unknown failure.',
                        suggestion: state.suggestion,
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        if (isNotBlank(state.metadata?.tagline) || isNotBlank(state.metadata?.summary))
                          MediaDetailsIosTabSummary(metadata: state.metadata),
                        const Gap(8),
                        MediaDetailsIosTabDetails(metadata: state.metadata),
                      ],
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
}
