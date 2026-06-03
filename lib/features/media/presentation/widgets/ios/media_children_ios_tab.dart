import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../bloc/children_metadata_bloc.dart';
import '../../pages/ios/media_ios_page.dart';
import 'media_list_ios_poster.dart';
import 'media_list_ios_thumbnail.dart';
import 'media_list_ios_track.dart';

class MediaChildrenIosTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;
  final MediaType mediaType;
  final Uri? parentPosterUri;

  const MediaChildrenIosTab({
    super.key,
    required this.server,
    required this.ratingKey,
    required this.mediaType,
    required this.parentPosterUri,
  });

  @override
  State<MediaChildrenIosTab> createState() => _MediaChildrenIosTabState();
}

class _MediaChildrenIosTabState extends State<MediaChildrenIosTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late ChildrenMetadataBloc _childrenMetadataBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _childrenMetadataBloc = context.read<ChildrenMetadataBloc>();
    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    late int crossAxistCount;

    if (widget.mediaType == MediaType.season) {
      if (screenWidth > 1000) {
        crossAxistCount = 6;
      } else if (screenWidth > 580) {
        crossAxistCount = 4;
      } else {
        crossAxistCount = 2;
      }
    } else {
      if (screenWidth > 1000) {
        crossAxistCount = 9;
      } else if (screenWidth > 580) {
        crossAxistCount = 6;
      } else {
        crossAxistCount = 3;
      }
    }

    return BlocBuilder<ChildrenMetadataBloc, ChildrenMetadataState>(
      builder: (context, state) {
        return CupertinoScrollbar(
          controller: _scrollController,
          child: CupertinoRefreshPage(
            scrollController: _scrollController,
            onRefresh: () {
              _childrenMetadataBloc.add(
                ChildrenMetadataFetched(
                  server: widget.server,
                  ratingKey: widget.ratingKey,
                  freshFetch: true,
                  settingsBloc: _settingsBloc,
                ),
              );

              return _refreshCompleter.future;
            },
            sliver: BlocConsumer<ChildrenMetadataBloc, ChildrenMetadataState>(
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

                      if (state.status == BlocStatus.initial && state.children == null) {
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

                      if (widget.mediaType == MediaType.album) {
                        return SliverList.separated(
                          itemCount: state.children?.length ?? 0,
                          separatorBuilder: (context, index) => const Gap(4),
                          itemBuilder: (context, index) {
                            final track = state.children?[index];

                            return MediaListIosTrack(
                              track: track!,
                              onTap: () async {
                                await Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => MediaIosPage(
                                      server: widget.server,
                                      disableAncestryNavigation: true,
                                      media: track,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxistCount,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          mainAxisExtent: _calculateCellHeight(screenWidth, crossAxistCount),
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: state.children?.length,
                          (context, index) {
                            final item = state.children![index];

                            if (item.mediaType == MediaType.episode) {
                              return Padding(
                                padding: const EdgeInsetsGeometry.all(4),
                                child: MediaListIosThumbnail(
                                  title: item.title,
                                  mediaIndex: item.mediaIndex,
                                  thumbUri: item.imageUri,
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => MediaIosPage(
                                          server: widget.server,
                                          media: item,
                                          disableAncestryNavigation: true,
                                          parentPosterUri: widget.parentPosterUri,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsetsGeometry.all(4),
                              child: MediaListIosPoster(
                                mediaType: item.mediaType,
                                title: item.title,
                                year: item.year,
                                ratingKey: item.ratingKey,
                                posterUri: item.imageUri,
                                onTap: () async {
                                  if (item.mediaType == MediaType.photoAlbum) {
                                    await Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => MediaIosPage(
                                          server: widget.server,
                                          disableAncestryNavigation: true,
                                          media: item,
                                        ),
                                      ),
                                    );
                                  } else {
                                    await Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => MediaIosPage(
                                          server: widget.server,
                                          disableAncestryNavigation: true,
                                          media: item,
                                        ),
                                      ),
                                    );
                                  }
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
      },
    );
  }

  double _calculateCellHeight(double screenWidth, int crossAxisCount) {
    final double itemWidth = (screenWidth - 16) / crossAxisCount;
    final bool isSquare = [
      MediaType.album,
      MediaType.artist,
      MediaType.photo,
      MediaType.photoAlbum,
      MediaType.track,
    ].contains(widget.mediaType);

    final double posterHeight = isSquare
        ? itemWidth
        : widget.mediaType == MediaType.season
        ? itemWidth * 2 / 3
        : itemWidth * 3 / 2;

    double textHeight = widget.mediaType == MediaType.season ? 44 : 26;

    return posterHeight + textHeight;
  }
}
