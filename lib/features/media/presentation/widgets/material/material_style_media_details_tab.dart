import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/page_body.dart';
import '../../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/metadata_bloc.dart';
import '../base/media_details_tab_details.dart';
import 'material_style_media_details_tab_summary.dart';

class MaterialStyleMediaDetailsTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;

  const MaterialStyleMediaDetailsTab({
    super.key,
    required this.server,
    required this.ratingKey,
  });

  @override
  State<MaterialStyleMediaDetailsTab> createState() => _MaterialStyleMediaDetailsTabState();
}

class _MaterialStyleMediaDetailsTabState extends State<MaterialStyleMediaDetailsTab> {
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetadataBloc, MetadataState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            context.read<MetadataBloc>().add(
              MetadataFetched(
                server: widget.server,
                ratingKey: widget.ratingKey,
                freshFetch: true,
                settingsBloc: _settingsBloc,
              ),
            );

            return Future.value();
          },
          child: PageBody(
            loading: state.status == BlocStatus.initial,
            child: Builder(
              builder: (context) {
                if (state.status == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  );
                }

                if (state.metadata != null) {
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      if (isNotBlank(state.metadata?.tagline) || isNotBlank(state.metadata?.summary))
                        MaterialStyleMediaDetailsTabSummary(metadata: state.metadata),
                      const Gap(8),
                      MediaDetailsTabDetails(
                        metadata: state.metadata,
                        titleColor: Colors.grey[500]!,
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}
