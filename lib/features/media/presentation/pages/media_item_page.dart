import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/media_item.dart';
import '../bloc/children_metadata_bloc.dart';
import '../bloc/metadata_bloc.dart';
import '../widgets/media_item_h1.dart';
import '../widgets/media_item_h2.dart';
import '../widgets/media_item_h3.dart';
import '../widgets/media_poster_loader.dart';
import '../widgets/media_tab_controller.dart';

class MediaItemPage extends StatelessWidget {
  final MediaItem item;
  final String syncedMediaType;
  final Object heroTag;
  final bool forceChildrenMetadataFetch;
  final bool enableNavOptions;
  final String tautulliIdOverride;

  const MediaItemPage({
    @required this.item,
    this.syncedMediaType,
    this.heroTag,
    this.forceChildrenMetadataFetch = false,
    this.enableNavOptions = false,
    this.tautulliIdOverride,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<MetadataBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ChildrenMetadataBloc>(),
        ),
      ],
      child: MediaItemPageContent(
        item: item,
        syncedMediaType: syncedMediaType,
        heroTag: heroTag,
        forceChildrenMetadataFetch: forceChildrenMetadataFetch,
        enableNavOptions: enableNavOptions,
        tautulliIdOverride: tautulliIdOverride,
      ),
    );
  }
}

class MediaItemPageContent extends StatefulWidget {
  final MediaItem item;
  final String syncedMediaType;
  final Object heroTag;
  final bool forceChildrenMetadataFetch;
  final bool enableNavOptions;
  final String tautulliIdOverride;

  const MediaItemPageContent({
    Key key,
    @required this.item,
    @required this.syncedMediaType,
    @required this.heroTag,
    @required this.forceChildrenMetadataFetch,
    @required this.enableNavOptions,
    this.tautulliIdOverride,
  }) : super(key: key);

  @override
  _MediaItemPageContentState createState() => _MediaItemPageContentState();
}

class _MediaItemPageContentState extends State<MediaItemPageContent> {
  SettingsBloc _settingsBloc;
  MetadataBloc _metadataBloc;
  ChildrenMetadataBloc _childrenMetadataBloc;
  String _tautulliId;
  String _plexIdentifier;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _metadataBloc = context.read<MetadataBloc>();
    _childrenMetadataBloc = context.read<ChildrenMetadataBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;
      String plexIdentifier;

      if (widget.tautulliIdOverride != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == widget.tautulliIdOverride) {
            lastSelectedServer = widget.tautulliIdOverride;
            plexIdentifier = server.plexIdentifier;
            break;
          }
        }
      } else if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            plexIdentifier = server.plexIdentifier;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
          _plexIdentifier = plexIdentifier;
        });
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
          _plexIdentifier = settingsState.serverList[0].plexIdentifier;
        });
      } else {
        _tautulliId = null;
      }

      _metadataBloc.add(
        MetadataFetched(
          tautulliId: _tautulliId,
          ratingKey: widget.item.ratingKey,
          syncId: widget.item.syncId,
          settingsBloc: _settingsBloc,
        ),
      );

      if (widget.forceChildrenMetadataFetch ||
          ['show', 'season', 'artist', 'album']
              .contains(widget.item.mediaType)) {
        _childrenMetadataBloc.add(
          ChildrenMetadataFetched(
            tautulliId: _tautulliId,
            ratingKey: widget.item.ratingKey,
            mediaType: widget.syncedMediaType,
            settingsBloc: _settingsBloc,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _appBarActions(
          item: widget.item,
          plexIdentifier: _plexIdentifier,
          enableNavOptions: widget.enableNavOptions,
          tautulliIdOverride: widget.tautulliIdOverride,
        ),
      ),
      body: Stack(
        children: [
          //* Background image
          ClipRect(
            child: Container(
              // Height is 185 to provide 10 pixels background to show
              // behind the rounded corners
              height: 195 +
                  10 +
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: BlocBuilder<MetadataBloc, MetadataState>(
                  builder: (context, state) {
                    if (widget.item.posterUrl != null) {
                      return Image.network(
                        widget.item.posterUrl,
                        fit: BoxFit.cover,
                      );
                    }
                    if (state is MetadataSuccess) {
                      return Image.network(
                        state.metadata.mediaType == 'episode'
                            ? state.metadata.grandparentPosterUrl
                            : state.metadata.posterUrl,
                        fit: BoxFit.cover,
                      );
                    }
                    return const SizedBox(height: 0, width: 0);
                  },
                ),
              ),
            ),
          ),
          //* Main body
          Column(
            children: [
              // Empty space for background to show
              SizedBox(
                height: 195 +
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height,
              ),
              //* Content area
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: PlexColorPalette.shark,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            //* Title section
                            Expanded(
                              child: Container(
                                height: 120,
                                // Make room for the poster
                                padding: const EdgeInsets.only(
                                  left: 137.0 + 8.0,
                                  top: 4,
                                  right: 4,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlocProvider.value(
                                      value: _metadataBloc,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MediaItemH1(
                                            item: widget.item,
                                          ),
                                          MediaItemH2(
                                            item: widget.item,
                                          ),
                                          MediaItemH3(
                                            item: widget.item,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: BlocBuilder<MetadataBloc, MetadataState>(
                            builder: (context, state) {
                              if (widget.item.mediaType != null) {
                                return MediaTabController(
                                  length: ['show', 'season', 'artist', 'album']
                                          .contains(widget.item.mediaType)
                                      ? 3
                                      : [
                                          'photo',
                                          'clip',
                                        ].contains(widget.item.mediaType)
                                          ? 1
                                          : 2,
                                  item: widget.item,
                                  mediaType: widget.item.mediaType,
                                );
                              } else {
                                if (state is MetadataInProgress) {
                                  return MediaTabController(
                                    length: 3,
                                    item: widget.item,
                                    mediaType: widget.item.mediaType,
                                  );
                                }
                                if (state is MetadataFailure) {
                                  return MediaTabController(
                                    length: 2,
                                    item: widget.item,
                                    metadataFailed: true,
                                  );
                                }
                                if (state is MetadataSuccess) {
                                  return MediaTabController(
                                    length: [
                                      'show',
                                      'season',
                                      'artist',
                                      'album',
                                    ].contains(state.metadata.mediaType)
                                        ? 3
                                        : [
                                            'photo',
                                            'clip',
                                          ].contains(state.metadata.mediaType)
                                            ? 1
                                            : 2,
                                    item: widget.item,
                                    mediaType: state.metadata.mediaType,
                                  );
                                }
                              }
                              return const SizedBox(height: 0, width: 0);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          //* Poster
          BlocBuilder<MetadataBloc, MetadataState>(
            builder: (context, state) {
              if (widget.item.posterUrl != null) {
                return MediaPosterLoader(
                  item: widget.item,
                  syncedMediaType: widget.syncedMediaType,
                  heroTag: widget.heroTag,
                  child: PosterChooser(item: widget.item),
                );
              }
              if (state is MetadataInProgress) {
                return MediaPosterLoader(
                  item: widget.item,
                  syncedMediaType: widget.syncedMediaType,
                  heroTag: widget.heroTag,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is MetadataSuccess) {
                final item = MediaItem(
                  posterUrl: state.metadata.mediaType == 'episode'
                      ? state.metadata.grandparentPosterUrl
                      : state.metadata.posterUrl,
                );

                return MediaPosterLoader(
                  item: widget.item,
                  syncedMediaType: widget.syncedMediaType,
                  heroTag: widget.heroTag,
                  child: PosterChooser(item: item),
                );
              }
              return const SizedBox(height: 0, width: 0);
            },
          ),
        ],
      ),
    );
  }
}

List<Widget> _appBarActions({
  @required MediaItem item,
  @required String plexIdentifier,
  @required bool enableNavOptions,
  String tautulliIdOverride,
}) {
  return [
    BlocBuilder<MetadataBloc, MetadataState>(
      builder: (context, state) {
        if (state is MetadataSuccess) {
          if (!['playlist'].contains(state.metadata.mediaType)) {
            return PopupMenuButton(
              tooltip: 'More options',
              onSelected: (value) {
                if (value == 'plex') {
                  _openPlexUrl(
                    plexIdentifier: plexIdentifier,
                    ratingKey:
                        !['track', 'photo'].contains(state.metadata.mediaType)
                            ? state.metadata.ratingKey
                            : state.metadata.parentRatingKey,
                    useLegacy:
                        ['photo', 'clip'].contains(state.metadata.mediaType),
                  );
                } else {
                  final keys = value.split('|');

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        MediaItem mediaItem = MediaItem(
                          mediaIndex: ['season', 'album'].contains(keys[0])
                              ? state.metadata.parentMediaIndex
                              : null,
                          mediaType: keys[0],
                          grandparentTitle: ['show', 'artist'].contains(keys[0])
                              ? state.metadata.grandparentTitle
                              : null,
                          parentMediaIndex: [
                            'show',
                            'artist',
                            'season',
                            'album'
                          ].contains(keys[0])
                              ? state.metadata.parentMediaIndex
                              : null,
                          parentTitle: ['show', 'artist', 'season', 'album']
                                  .contains(keys[0])
                              ? state.metadata.grandparentTitle
                              : null,
                          posterUrl: (keys[0] == 'show' && keys[1] == 'episode')
                              ? state.metadata.grandparentPosterUrl
                              : state.metadata.parentPosterUrl,
                          ratingKey: (keys[0] == 'show' && keys[1] == 'episode')
                              ? state.metadata.grandparentRatingKey
                              : state.metadata.parentRatingKey,
                          title: (keys[0] == 'show' && keys[1] == 'episode')
                              ? state.metadata.grandparentTitle
                              : state.metadata.parentTitle,
                        );

                        return MediaItemPage(
                          item: mediaItem,
                          enableNavOptions: enableNavOptions,
                          tautulliIdOverride: tautulliIdOverride,
                        );
                      },
                    ),
                  );
                }
              },
              itemBuilder: (context) {
                return [
                  if (enableNavOptions &&
                      ['season', 'episode'].contains(state.metadata.mediaType))
                    PopupMenuItem(
                      value: 'show|${state.metadata.mediaType}',
                      child: const Text('Go to show'),
                    ),
                  if (enableNavOptions &&
                      ['episode'].contains(state.metadata.mediaType))
                    PopupMenuItem(
                      value: 'season|${state.metadata.mediaType}',
                      child: const Text('Go to season'),
                    ),
                  if (enableNavOptions &&
                      ['album', 'track'].contains(state.metadata.mediaType))
                    PopupMenuItem(
                      value: 'artist|${state.metadata.mediaType}',
                      child: const Text('Go to artist'),
                    ),
                  const PopupMenuItem(
                    value: 'plex',
                    child: Text('View on Plex'),
                  ),
                  // if (['track'].contains(state.metadata.mediaType))
                  //   PopupMenuItem(
                  //     value: 'album|${state.metadata.mediaType}',
                  //     child: Text('Go to album'),
                  //   ),
                ];
              },
            );
          }
          return const IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: null,
          );
        }
        return const IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: null,
        );
      },
    ),
  ];
}

Future<void> _openPlexUrl({
  @required int ratingKey,
  @required String plexIdentifier,
  bool useLegacy = false,
}) async {
  String plexAppUrl =
      'plex://server://$plexIdentifier/com.plexapp.plugins.library/library/metadata/$ratingKey';
  String plexWebUrl =
      'https://app.plex.tv/desktop#!/server/$plexIdentifier/details?key=%2Flibrary%2Fmetadata%2F$ratingKey${useLegacy ? '&legacy=1' : ''}';

  if (await canLaunch(plexAppUrl)) {
    await launch(plexAppUrl);
  } else {
    await launch(plexWebUrl);
  }
}
