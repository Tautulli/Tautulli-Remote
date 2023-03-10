import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/children_metadata_bloc.dart';
import '../pages/media_page.dart';
import 'media_list_poster.dart';
import 'media_list_thumbnail.dart';
import 'media_list_track.dart';

class MediaChildrenTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;
  final MediaType mediaType;
  final Uri? parentPosterUri;

  const MediaChildrenTab({
    super.key,
    required this.server,
    required this.ratingKey,
    required this.mediaType,
    required this.parentPosterUri,
  });

  @override
  State<MediaChildrenTab> createState() => _MediaChildrenTabState();
}

class _MediaChildrenTabState extends State<MediaChildrenTab> {
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

    return BlocBuilder<ChildrenMetadataBloc, ChildrenMetadataState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            _childrenMetadataBloc.add(
              ChildrenMetadataFetched(
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
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Builder(builder: (context) {
                    if (widget.mediaType == MediaType.album) {
                      return ListView.separated(
                        itemCount: state.children?.length ?? 0,
                        padding: const EdgeInsets.all(4),
                        separatorBuilder: (context, index) => const Gap(8),
                        itemBuilder: (context, index) {
                          final track = state.children?[index];

                          return MediaListTrack(
                            track: track!,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MediaPage(
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

                    return GridView.count(
                      crossAxisCount: crossAxistCount,
                      childAspectRatio: [
                        MediaType.album,
                        MediaType.artist,
                        MediaType.photo,
                        MediaType.photoAlbum,
                        MediaType.track,
                      ].contains(widget.mediaType)
                          ? 1
                          : widget.mediaType == MediaType.season
                              ? 3 / 2
                              : 2 / 3,
                      children: state.children != null
                          ? state.children!.map(
                              (item) {
                                if ([MediaType.episode].contains(item.mediaType)) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: MediaListThumbnail(
                                      title: item.title,
                                      mediaIndex: item.mediaIndex,
                                      thumbUri: item.imageUri,
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MediaPage(
                                              server: widget.server,
                                              disableAncestryNavigation: true,
                                              media: item,
                                              parentPosterUri: widget.parentPosterUri,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: MediaListPoster(
                                    mediaType: item.mediaType,
                                    title: item.title,
                                    year: item.year,
                                    ratingKey: item.ratingKey,
                                    posterUri: item.imageUri,
                                    onTap: () async {
                                      if (item.mediaType == MediaType.photoAlbum) {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MediaPage(
                                              server: widget.server,
                                              disableAncestryNavigation: true,
                                              media: item,
                                            ),
                                          ),
                                        );
                                      } else {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MediaPage(
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
                            ).toList()
                          : [],
                    );
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
