import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/clean_data_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_chooser.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../bloc/library_media_bloc.dart';
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

  const MediaItemPage({
    @required this.item,
    this.heroTag,
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
          create: (context) => di.sl<LibraryMediaBloc>(),
        ),
      ],
      child: MediaItemPageContent(
        item: item,
        heroTag: heroTag,
      ),
    );
  }
}

class MediaItemPageContent extends StatefulWidget {
  final MediaItem item;
  final Object heroTag;

  const MediaItemPageContent({
    Key key,
    @required this.item,
    this.heroTag,
  }) : super(key: key);

  @override
  _MediaItemPageContentState createState() => _MediaItemPageContentState();
}

class _MediaItemPageContentState extends State<MediaItemPageContent> {
  SettingsBloc _settingsBloc;
  MetadataBloc _metadataBloc;
  LibraryMediaBloc _libraryMediaBloc;
  String _tautulliId;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _metadataBloc = context.read<MetadataBloc>();
    _libraryMediaBloc = context.read<LibraryMediaBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
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

      if (['show', 'season', 'artist', 'album']
          .contains(widget.item.mediaType)) {
        _libraryMediaBloc.add(
          LibraryMediaFetched(
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
      ),
      body: Stack(
        children: [
          //* Background image
          ClipRect(
            child: Container(
              // Height is 185 to provide 10 pixels background to show
              // behind the rounded corners
              height: 185 +
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
                height: 175 +
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
                                height: 150,
                                // Make room for the poster
                                padding: const EdgeInsets.only(
                                  left: 134.0 + 8.0,
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
                                    BlocBuilder<MetadataBloc, MetadataState>(
                                      builder: (context, state) {
                                        if (state is MetadataSuccess) {
                                          return _MediaFlagsRow(
                                            item: widget.item,
                                            metadata: state.metadata,
                                          );
                                        }
                                        return SizedBox(height: 0, width: 0);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: ['show', 'season', 'artist', 'album']
                                    .contains(widget.item.mediaType)
                                ? 3
                                : 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.label,
                                    tabs: _tabBuilder(
                                      mediaType: widget.item.mediaType,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _TabContents(
                                    item: widget.item,
                                  ),
                                ),
                              ],
                            ),
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
            top: MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height +
                125,
            child: Container(
              height: 200,
              padding: EdgeInsets.only(left: 4),
              child: Hero(
                tag: widget.heroTag ?? UniqueKey(),
                child: PosterChooser(item: widget.item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _tabBuilder({
  @required String mediaType,
}) {
  return [
    Tab(
      text: 'Details',
    ),
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
    Tab(
      text: 'History',
    ),
  ];
}

class _TabContents extends StatelessWidget {
  final MediaItem item;

  const _TabContents({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // Details Tab
        BlocBuilder<MetadataBloc, MetadataState>(
          builder: (context, state) {
            if (state is MetadataFailure) {
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
            if (state is MetadataSuccess) {
              return DetailsTab(metadata: state.metadata);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // Seasons/Episodes/Albums/Tracks tab
        if (['show', 'season', 'artist', 'album'].contains(item.mediaType))
          BlocBuilder<LibraryMediaBloc, LibraryMediaState>(
            builder: (context, state) {
              if (state is LibraryMediaFailure) {
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
              if (state is LibraryMediaSuccess) {
                if (item.mediaType == 'show') {
                  return SeasonsTab(
                    item: item,
                    seasons: state.libraryMediaList,
                  );
                }
                if (item.mediaType == 'season') {
                  return EpisodesTab(
                    item: item,
                    episodes: state.libraryMediaList,
                  );
                }
                if (item.mediaType == 'artist') {
                  return AlbumsTab(
                    item: item,
                    albums: state.libraryMediaList,
                  );
                }
                if (item.mediaType == 'album') {
                  return TracksTab(
                    item: item,
                    tracks: state.libraryMediaList,
                  );
                }
                return Text('UNKNOWN MEDIA TYPE ${item.mediaType}');
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        // History Tab
        HistoryTab(
          ratingKey: item.ratingKey,
          mediaType: item.mediaType,
        ),
      ],
    );
  }
}

class _MediaFlagsRow extends StatelessWidget {
  final MediaItem item;
  final MetadataItem metadata;

  const _MediaFlagsRow({
    Key key,
    @required this.item,
    @required this.metadata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isNotEmpty(metadata.videoCodec))
          Expanded(
            child: _MediaFlagsTag(
              detail: metadata.videoCodec.toUpperCase(),
            ),
          ),
        if (isNotEmpty(metadata.videoCodec))
          SizedBox(
            width: 4,
          ),
        if (isNotEmpty(metadata.videoFullResolution))
          Expanded(
            child: _MediaFlagsTag(
              detail: metadata.videoFullResolution.contains('k')
                  ? metadata.videoFullResolution.toUpperCase()
                  : metadata.videoFullResolution,
            ),
          ),
        if (isNotEmpty(metadata.videoFullResolution))
          SizedBox(
            width: 4,
          ),
        if (isNotEmpty(metadata.audioCodec))
          Expanded(
            child: _MediaFlagsTag(
              detail: metadata.audioCodec.toUpperCase(),
            ),
          ),
        if (isNotEmpty(metadata.audioCodec))
          SizedBox(
            width: 4,
          ),
        if (isNotEmpty(metadata.audioChannels.toString()))
          Expanded(
            child: _MediaFlagsTag(
              detail: MediaFlagsCleaner.audioChannels(
                metadata.audioChannels.toString(),
              ),
            ),
          ),
      ],
    );
  }
}

class _MediaFlagsTag extends StatelessWidget {
  final String detail;

  const _MediaFlagsTag({
    @required this.detail,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ![null, 'null'].contains(detail)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 30,
              color: Colors.black26,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(detail),
                ),
              ),
            ),
          )
        : SizedBox(height: 0, width: 0);
  }
}
