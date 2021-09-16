// @dart=2.9

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../bloc/library_media_bloc.dart';
import '../widgets/library_history_tab.dart';
import '../widgets/library_media_tab.dart';
import '../widgets/library_recent_tab.dart';
import '../widgets/library_stats_tab.dart';

class LibraryDetailsPage extends StatelessWidget {
  final Library library;
  final int ratingKey;
  final String sectionType;
  final String title;
  final Key heroTag;
  final String backgroundUrlOverride;
  final bool disableStatsTab;

  const LibraryDetailsPage({
    this.library,
    this.ratingKey,
    this.sectionType,
    this.title,
    this.heroTag,
    this.backgroundUrlOverride,
    this.disableStatsTab = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibraryMediaBloc>(),
      child: LibraryDetailsPageContent(
        library: library,
        ratingKey: ratingKey,
        title: title,
        sectionType: sectionType,
        heroTag: heroTag,
        backgroundUrlOverride: backgroundUrlOverride,
        disableStatsTab: disableStatsTab,
      ),
    );
  }
}

class LibraryDetailsPageContent extends StatefulWidget {
  final Library library;
  final int ratingKey;
  final String sectionType;
  final String title;
  final Key heroTag;
  final String backgroundUrlOverride;
  final bool disableStatsTab;

  const LibraryDetailsPageContent({
    @required this.library,
    @required this.ratingKey,
    @required this.sectionType,
    @required this.title,
    @required this.heroTag,
    @required this.backgroundUrlOverride,
    @required this.disableStatsTab,
    Key key,
  }) : super(key: key);

  @override
  _LibraryDetailsPageContentState createState() =>
      _LibraryDetailsPageContentState();
}

class _LibraryDetailsPageContentState extends State<LibraryDetailsPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  LibraryMediaBloc _libraryMediaBloc;
  String _tautulliId;
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _libraryMediaBloc = context.read<LibraryMediaBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;

            for (CustomHeaderModel header in server.customHeaders) {
              headerMap[header.key] = header.value;
            }

            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
          for (CustomHeaderModel header
              in settingsState.serverList[0].customHeaders) {
            headerMap[header.key] = header.value;
          }
        });
      } else {
        _tautulliId = null;
      }

      _libraryMediaBloc.add(
        LibraryMediaFetched(
          tautulliId: _tautulliId,
          sectionId: widget.library != null ? widget.library.sectionId : null,
          ratingKey: widget.ratingKey,
          settingsBloc: context.read<SettingsBloc>(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String sectionType = widget.sectionType ?? widget.library.sectionType;
    final String backgroundUrl =
        widget.backgroundUrlOverride ?? widget.library.backgroundUrl;
    bool hasNetworkImage =
        backgroundUrl != null ? backgroundUrl.startsWith('http') : false;
    Future getColorFuture = _getColor(
      hasNetworkImage,
      backgroundUrl,
      headerMap,
    );

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
                child: sectionType != 'live'
                    ? Image(
                        image: CachedNetworkImageProvider(
                          widget.backgroundUrlOverride != null
                              ? widget.backgroundUrlOverride
                              : widget.library.backgroundUrl,
                          headers: headerMap,
                        ),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/livetv_fallback.png',
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
                                height: 60,
                                // Make room for the poster
                                padding: const EdgeInsets.only(
                                  left: 107.0 + 8.0,
                                  top: 4,
                                  right: 4,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title ??
                                          widget.library.sectionName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    widget.library is Library &&
                                            widget.library.lastAccessed != null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${LocaleKeys.general_details_streamed.tr()} ',
                                                  ),
                                                  TextSpan(
                                                    text: widget.library
                                                                .lastAccessed >=
                                                            0
                                                        ? '${TimeFormatHelper.timeAgo(widget.library.lastAccessed)}'
                                                        : LocaleKeys
                                                            .general_never
                                                            .tr(),
                                                    style: const TextStyle(
                                                      color: PlexColorPalette
                                                          .gamboge,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(height: 0, width: 0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: widget.disableStatsTab
                                ? 1
                                : sectionType == 'photo'
                                    ? 2
                                    : 4,
                            child: Column(
                              children: [
                                TabBar(
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: [
                                    if (!widget.disableStatsTab)
                                      Tab(
                                        child: const Text(
                                          LocaleKeys.general_details_tab_stats,
                                        ).tr(),
                                      ),
                                    if (sectionType != 'photo')
                                      Tab(
                                        child: const Text(
                                          LocaleKeys.libraries_details_tab_new,
                                        ).tr(),
                                      ),
                                    if (sectionType != 'photo')
                                      Tab(
                                        child: const Text(
                                          LocaleKeys.history_page_title,
                                        ).tr(),
                                      ),
                                    Tab(
                                      child: const Text(LocaleKeys
                                              .libraries_details_tab_media)
                                          .tr(),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      if (!widget.disableStatsTab)
                                        LibraryStatsTab(
                                          sectionId: widget.library.sectionId,
                                        ),
                                      if (sectionType != 'photo')
                                        LibraryRecentTab(
                                          sectionId: widget.library.sectionId,
                                        ),
                                      if (sectionType != 'photo')
                                        LibraryHistoryTab(
                                          sectionId: widget.library.sectionId,
                                        ),
                                      LibraryMediaTab(
                                        tautulliId: _tautulliId,
                                        library: widget.library,
                                        sectionType: sectionType,
                                        title: widget.title,
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
                  ),
                ),
              ),
            ],
          ),
          //* Library Icon
          Positioned(
            top: 155 +
                MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height,
            left: 8,
            child: SizedBox(
              height: 100,
              width: 100,
              child: widget.backgroundUrlOverride == null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: FutureBuilder(
                            future: getColorFuture,
                            builder: (context, snapshot) {
                              bool hasCustomColor = snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data['color'] != null;

                              return ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      color: hasCustomColor
                                          ? snapshot.data['color']
                                          : TautulliColorPalette.midnight,
                                    ),
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Center(
                          child: Hero(
                            tag: widget.heroTag ?? UniqueKey(),
                            child: SizedBox(
                              height: 65,
                              width: 65,
                              child: widget.library.iconUrl != null
                                  ? Image(
                                      image: CachedNetworkImageProvider(
                                        widget.library.iconUrl,
                                        headers: headerMap,
                                      ),
                                      fit: BoxFit.contain,
                                    )
                                  : WebsafeSvg.asset(
                                      AssetMapperHelper.mapLibraryToPath(
                                        sectionType,
                                      ),
                                      color: TautulliColorPalette.not_white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Hero(
                      tag: widget.heroTag ?? UniqueKey(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image(
                          image: CachedNetworkImageProvider(
                            widget.backgroundUrlOverride,
                            headers: headerMap,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _libraryMediaBloc.add(
        LibraryMediaFetched(
          tautulliId: _tautulliId,
          sectionId: widget.library != null ? widget.library.sectionId : null,
          ratingKey: widget.ratingKey,
          settingsBloc: context.read<SettingsBloc>(),
        ),
      );
    }
  }
}

Future<Map<String, dynamic>> _getColor(
  bool hasUrl,
  String url,
  Map<String, String> headerMap,
) async {
  if (hasUrl) {
    NetworkImage backgroundImage = NetworkImage(
      url,
      headers: headerMap,
    );
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(
        url,
        headers: headerMap,
      ),
      maximumColorCount: 12,
    );
    return {
      'image': backgroundImage,
      'color': palette.mutedColor.color != null
          ? palette.mutedColor.color
          : palette.dominantColor.color,
    };
  }
  return {
    'image': null,
    'color': TautulliColorPalette.midnight,
  };
}
