import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/media_item.dart';
import '../bloc/children_metadata_bloc.dart';
import '../bloc/metadata_bloc.dart';
import '../widgets/albums_tab.dart';
import '../widgets/details_tab.dart';
import '../widgets/episodes_tab.dart';
import '../widgets/history_tab.dart';
import '../widgets/media_item_h1.dart';
import '../widgets/media_item_h2.dart';
import '../widgets/media_item_h3.dart';
import '../widgets/seasons_tab.dart';
import '../widgets/tracks_tab.dart';

class MediaItemPage extends StatelessWidget {
  final MediaItem item;
  final Object heroTag;
  final bool forceChildrenMetadataFetch;
  final bool enableNavOptions;

  const MediaItemPage({
    @required this.item,
    this.heroTag,
    this.forceChildrenMetadataFetch = false,
    this.enableNavOptions = false,
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
        heroTag: heroTag,
        forceChildrenMetadataFetch: forceChildrenMetadataFetch,
        enableNavOptions: enableNavOptions,
      ),
    );
  }
}

class MediaItemPageContent extends StatefulWidget {
  final MediaItem item;
  final Object heroTag;
  final bool forceChildrenMetadataFetch;
  final bool enableNavOptions;

  const MediaItemPageContent({
    Key key,
    @required this.item,
    @required this.heroTag,
    @required this.forceChildrenMetadataFetch,
    @required this.enableNavOptions,
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

      if (settingsState.lastSelectedServer != null) {
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
      } else if (settingsState.serverList.length > 0) {
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
        ),
      );

      if (widget.forceChildrenMetadataFetch ||
          ['show', 'season', 'artist', 'album']
              .contains(widget.item.mediaType)) {
        _childrenMetadataBloc.add(
          ChildrenMetadataFetched(
            tautulliId: _tautulliId,
            ratingKey: widget.item.ratingKey,
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
                child: Image.network(
                  widget.item.posterUrl != null ? widget.item.posterUrl : '',
                  fit: BoxFit.cover,
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
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
                                return _TabController(
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
                                  return _TabController(
                                    length: 3,
                                    item: widget.item,
                                    mediaType: widget.item.mediaType,
                                  );
                                }
                                if (state is MetadataFailure) {
                                  return _TabController(
                                    length: 2,
                                    item: widget.item,
                                    metadataFailed: true,
                                  );
                                }
                                if (state is MetadataSuccess) {
                                  return _TabController(
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
                                          ].contains(widget.item.mediaType)
                                            ? 1
                                            : 2,
                                    item: widget.item,
                                    mediaType: state.metadata.mediaType,
                                  );
                                }
                              }
                              return SizedBox();
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
          Positioned(
            top: [
              'artist',
              'album',
              'track',
              'photo',
            ].contains(widget.item.mediaType)
                ? MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height +
                    115 +
                    63
                : MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height +
                    115,
            child: Container(
              width: 137,
              padding: EdgeInsets.only(left: 4),
              child: Hero(
                tag: widget.heroTag ?? UniqueKey(),
                child: AspectRatio(
                  aspectRatio: [
                    'artist',
                    'album',
                    'track',
                    'photo',
                  ].contains(widget.item.mediaType)
                      ? 1
                      : 2 / 3,
                  child: PosterChooser(item: widget.item),
                ),
              ),
            ),
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
}) {
  return [
    BlocBuilder<MetadataBloc, MetadataState>(
      builder: (context, state) {
        if (state is MetadataSuccess) {
          if (!['photo', 'clip'].contains(state.metadata.mediaType)) {
            return PopupMenuButton(
              tooltip: 'More options',
              onSelected: (value) {
                if (value == 'plex') {
                  _openPlexUrl(
                    plexIdentifier: plexIdentifier,
                    ratingKey: state.metadata.ratingKey,
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
                      child: Text('Go to show'),
                    ),
                  if (enableNavOptions &&
                      ['episode'].contains(state.metadata.mediaType))
                    PopupMenuItem(
                      value: 'season|${state.metadata.mediaType}',
                      child: Text('Go to season'),
                    ),
                  if (enableNavOptions &&
                      ['album', 'track'].contains(state.metadata.mediaType))
                    PopupMenuItem(
                      value: 'artist|${state.metadata.mediaType}',
                      child: Text('Go to artist'),
                    ),
                  PopupMenuItem(
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
          return IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: null,
          );
        }
        return IconButton(
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
}) async {
  String plexAppUrl =
      'plex://server://$plexIdentifier/com.plexapp.plugins.library/library/metadata/$ratingKey';
  String plexWebUrl =
      'https://app.plex.tv/desktop#!/server/$plexIdentifier/details?key=%2Flibrary%2Fmetadata%2F$ratingKey';

  if (await canLaunch(plexAppUrl)) {
    print(plexAppUrl);
    await launch(plexAppUrl);
  } else {
    print(plexWebUrl);
    await launch(plexWebUrl);
  }
}

class _TabController extends StatelessWidget {
  final int length;
  final String mediaType;
  final MediaItem item;
  final bool metadataFailed;

  const _TabController({
    @required this.length,
    @required this.item,
    this.mediaType,
    this.metadataFailed = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _tabBuilder(
                mediaType: mediaType,
                metadataFailed: metadataFailed,
              ),
            ),
          ),
          Expanded(
            child: _TabContents(
              item: item,
              mediaType: mediaType,
              metadataFailed: metadataFailed,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _tabBuilder({
  String mediaType,
  bool metadataFailed = false,
}) {
  return [
    Tab(
      text: 'Details',
    ),
    if (mediaType == null && !metadataFailed)
      Tab(
        child: SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    // if (mediaType != null)
    if (['show', 'season', 'artist', 'album'].contains(mediaType))
      Tab(
        text: mediaType == 'show'
            ? 'Seasons'
            : mediaType == 'season'
                ? 'Episodes'
                : mediaType == 'artist'
                    ? 'Albums'
                    : 'Tracks',
      ),
    if (![
      'photo',
      'clip',
    ].contains(mediaType))
      Tab(
        text: 'History',
      ),
  ];
}

class _TabContents extends StatelessWidget {
  final MediaItem item;
  final String mediaType;
  final bool metadataFailed;

  const _TabContents({
    @required this.item,
    this.mediaType,
    this.metadataFailed = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // Details Tab
        DetailsTab(),
        // Loading tab for when no mediaType is provided and we need to get
        // it from the fetched metadata
        if (mediaType == null && item.mediaType == null && !metadataFailed)
          Center(
            child: CircularProgressIndicator(),
          ),
        // Seasons/Episodes/Albums/Tracks tab
        if (['show', 'season', 'artist', 'album']
            .contains(mediaType ?? item.mediaType))
          BlocBuilder<ChildrenMetadataBloc, ChildrenMetadataState>(
            builder: (context, state) {
              if (state is ChildrenMetadataFailure) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorMessage(
                      failure: state.failure,
                      message: state.message,
                      suggestion: state.suggestion,
                    ),
                  ],
                );
              }
              if (state is ChildrenMetadataSuccess) {
                if (['show'].contains(mediaType ?? item.mediaType)) {
                  return SeasonsTab(
                    item: item,
                    seasons: state.childrenMetadataList,
                  );
                }
                if (['season'].contains(mediaType ?? item.mediaType)) {
                  return EpisodesTab(
                    item: item,
                    episodes: state.childrenMetadataList,
                  );
                }
                if (['artist'].contains(mediaType ?? item.mediaType)) {
                  return AlbumsTab(
                    item: item,
                    albums: state.childrenMetadataList,
                  );
                }
                if (['album'].contains(mediaType ?? item.mediaType)) {
                  return TracksTab(
                    item: item,
                    tracks: state.childrenMetadataList,
                  );
                }
                return Text(
                    'UNKNOWN MEDIA TYPE ${mediaType ?? item.mediaType}');
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        // History Tab
        if (![
          'photo',
          'clip',
        ].contains(item.mediaType))
          HistoryTab(
            ratingKey: item.ratingKey,
            mediaType: mediaType ?? item.mediaType,
          ),
      ],
    );
  }
}
