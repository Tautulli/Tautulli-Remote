import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/types/section_type.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/cupertino/cupertino_style_media_page.dart';
import '../../../../media/presentation/widgets/cupertino/cupertino_style_media_list_poster.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';
import '../../bloc/library_media_bloc.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleLibraryDetailsMediaTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;
  final String? currentPageTitle;

  const CupertinoStyleLibraryDetailsMediaTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
    this.currentPageTitle,
  });

  @override
  State<CupertinoStyleLibraryDetailsMediaTab> createState() => _CupertinoStyleLibraryDetailsMediaTabState();
}

class _CupertinoStyleLibraryDetailsMediaTabState extends State<CupertinoStyleLibraryDetailsMediaTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late SettingsBloc _settingsBloc;
  late bool _libraryMediaFullRefresh;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _libraryMediaFullRefresh = settingsState.appSettings.libraryMediaFullRefresh;
  }

  @override
  void dispose() {
    if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoStyleRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          context.read<LibraryMediaBloc>().add(
            LibraryMediaFetched(
              server: widget.server,
              sectionId: widget.libraryTableModel.sectionId!,
              refresh: true,
              fullRefresh: _libraryMediaFullRefresh,
            ),
          );

          //TODO: Add message about full library refresh

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<LibraryMediaBloc, LibraryMediaState>(
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

                  if (state.status == BlocStatus.initial && state.libraryItems.isEmpty) {
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

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 1000
                          ? 9
                          : screenWidth > 580
                          ? 6
                          : 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      mainAxisExtent: _calculateCellHeight(screenWidth),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: state.libraryItems.length,
                      (context, index) {
                        final item = state.libraryItems[index];

                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: CupertinoStyleMediaListPoster(
                            mediaType: item.mediaType,
                            title: item.title,
                            ratingKey: item.ratingKey,
                            posterUri: item.posterUri,
                            onTap: () async {
                              final media = MediaModel(
                                grandparentRatingKey: item.grandparentRatingKey,
                                // grandparentTitle: item.grandparentTitle,
                                imageUri: item.posterUri,
                                // live: item.live,
                                mediaIndex: item.mediaIndex,
                                mediaType: item.mediaType,
                                parentMediaIndex: item.parentMediaIndex,
                                parentRatingKey: item.parentRatingKey,
                                parentTitle: widget.libraryTableModel.sectionName,
                                ratingKey: item.ratingKey,
                                title: item.title,
                                year: item.year,
                              );

                              await Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => CupertinoStyleMediaPage(
                                    server: widget.server,
                                    media: media,
                                    disableAppBarActions: item.mediaType == MediaType.photo,
                                    previousPageTitle: widget.currentPageTitle,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
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

  double _calculateCellHeight(double screenWidth) {
    final int crossAxisCount = screenWidth > 1000
        ? 9
        : screenWidth > 580
        ? 6
        : 3;
    final double itemWidth = (screenWidth - 16) / crossAxisCount;
    final bool isSquare = [
      SectionType.artist,
      SectionType.playlist,
      SectionType.photo,
    ].contains(widget.libraryTableModel.sectionType);

    final double posterHeight = isSquare ? itemWidth : itemWidth * 3 / 2;
    const double textHeight = 28;

    return posterHeight + textHeight;
  }
}
