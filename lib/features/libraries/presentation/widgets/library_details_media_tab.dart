import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/types/section_type.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../../media/presentation/widgets/media_list_poster.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_media_info_model.dart';
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
  late bool _libraryMediaFullRefresh;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;
    _libraryMediaFullRefresh = settingsState.appSettings.libraryMediaFullRefresh;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryMediaBloc, LibraryMediaState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            context.read<LibraryMediaBloc>().add(
                  LibraryMediaFetched(
                    tautulliId: _tautulliId,
                    sectionId: widget.libraryTableModel.sectionId!,
                    refresh: true,
                    fullRefresh: _libraryMediaFullRefresh,
                    settingsBloc: _settingsBloc,
                  ),
                );

            if (_libraryMediaFullRefresh) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    LocaleKeys.library_media_full_refresh_snackbar_message,
                  ).tr(),
                  action: SnackBarAction(
                    label: LocaleKeys.learn_more_button.tr(),
                    onPressed: () async {
                      await launchUrlString(
                        mode: LaunchMode.externalApplication,
                        'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#library_refresh',
                      );
                    },
                  ),
                ),
              );
            }

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
                        SectionType.artist,
                        SectionType.playlist,
                        SectionType.photo,
                      ].contains(widget.libraryTableModel.sectionType)
                          ? 1
                          : 2 / 3,
                      children: state.libraryItems
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.all(4),
                              child: MediaListPoster(
                                mediaType: item.mediaType,
                                title: item.title,
                                ratingKey: item.ratingKey,
                                posterUri: item.posterUri,
                                onTap: () async {
                                  if (item.mediaType == MediaType.photoAlbum) {
                                  } else {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MediaPage(
                                          mediaType: item.mediaType ?? MediaType.unknown,
                                          posterUri: item.posterUri,
                                          title: item.title,
                                          subtitle: _buildSubtitle(item),
                                          ratingKey: item.ratingKey!,
                                        ),
                                      ),
                                    );
                                  }
                                },
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

  Text? _buildSubtitle(LibraryMediaInfoModel model) {
    if ([
          MediaType.movie,
          MediaType.show,
        ].contains(model.mediaType) &&
        model.year != null) {
      return Text(model.year.toString());
    }

    if (model.mediaType == MediaType.photo) {
      return Text(widget.libraryTableModel.sectionName ?? '');
    }

    return null;
  }
}
