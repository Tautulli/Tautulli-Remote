import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../media/presentation/widgets/media_list_poster.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';
import '../bloc/library_media_bloc.dart';

class LibraryDetailsMediaTab extends StatefulWidget {
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsMediaTab({
    super.key,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsMediaTab> createState() => _LibraryDetailsMediaTabState();
}

class _LibraryDetailsMediaTabState extends State<LibraryDetailsMediaTab> {
  late SettingsBloc _settingsBloc;
  late String _tautulliId;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryMediaBloc, LibraryMediaState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            // context.read<LibraryStatisticsBloc>().add(
            //       LibraryStatisticsFetched(
            //         tautulliId: _tautulliId,
            //         sectionId: widget.libraryTableModel.sectionId!,
            //         settingsBloc: _settingsBloc,
            //         freshFetch: true,
            //       ),
            //     );

            return Future.value();
          },
          child: PageBody(
            loading: state.status == BlocStatus.initial,
            child: Builder(
              builder: (context) {
                if (state.status == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                return VsScrollbar(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: [
                        MediaType.album,
                        MediaType.artist,
                        MediaType.track,
                        MediaType.playlist,
                      ].contains(widget.libraryTableModel.mediaType)
                          ? 1
                          : 2 / 3,
                      children: state.libraryItems
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.all(4),
                              child: MediaListPoster(
                                mediaType: widget.libraryTableModel.mediaType,
                                libraryMediaInfoModel: item,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
