import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/children_metadata_bloc.dart';
import '../bloc/metadata_bloc.dart';
import '../widgets/media_children_tab.dart';
import '../widgets/media_details_tab.dart';
import '../widgets/media_history_tab.dart';
import 'sliver_tabbed_poster_details_page.dart';

class MediaPage extends StatelessWidget {
  final MediaType mediaType;
  final Uri? posterUri;
  final String? title;
  final Widget? subtitle;
  final Widget? itemDetail;
  final int ratingKey;

  const MediaPage({
    super.key,
    required this.mediaType,
    this.posterUri,
    this.title,
    this.subtitle,
    this.itemDetail,
    required this.ratingKey,
  });

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
        BlocProvider(
          create: (context) => di.sl<IndividualHistoryBloc>(),
        ),
      ],
      child: MediaView(
        mediaType: mediaType,
        posterUri: posterUri,
        title: title,
        subtitle: subtitle,
        itemDetail: itemDetail,
        ratingKey: ratingKey,
      ),
    );
  }
}

class MediaView extends StatefulWidget {
  final MediaType mediaType;
  final Uri? posterUri;
  final String? title;
  final Widget? subtitle;
  final Widget? itemDetail;
  final int ratingKey;

  const MediaView({
    super.key,
    required this.mediaType,
    this.posterUri,
    this.title,
    this.subtitle,
    this.itemDetail,
    required this.ratingKey,
  });

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  @override
  void initState() {
    super.initState();

    final settingsBloc = context.read<SettingsBloc>();
    final settingsState = settingsBloc.state as SettingsSuccess;
    final tautulliId = settingsState.appSettings.activeServer.tautulliId;

    context.read<MetadataBloc>().add(
          MetadataFetched(
            tautulliId: tautulliId,
            ratingKey: widget.ratingKey,
            settingsBloc: settingsBloc,
          ),
        );

    context.read<IndividualHistoryBloc>().add(
          IndividualHistoryFetched(
            tautulliId: tautulliId,
            ratingKey: widget.ratingKey,
            mediaType: widget.mediaType,
            settingsBloc: settingsBloc,
          ),
        );

    if ([
      MediaType.show,
      MediaType.artist,
      MediaType.album,
      MediaType.season,
    ].contains(widget.mediaType)) {
      context.read<ChildrenMetadataBloc>().add(
            ChildrenMetadataFetched(
              tautulliId: tautulliId,
              ratingKey: widget.ratingKey,
              settingsBloc: settingsBloc,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverTabbedPosterDetailsPage(
        background: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CachedNetworkImage(
              imageUrl: widget.posterUri.toString(),
              httpHeaders: {
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                  headerModel.key: headerModel.value,
              },
              imageBuilder: (context, imageProvider) => ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                  tileMode: TileMode.decal,
                ),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
              placeholder: (context, url) => Image.asset('assets/images/art_fallback.png'),
              errorWidget: (context, url, error) => Image.asset('assets/images/art_error.png'),
            );
          },
        ),
        appBarActions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [];
            },
          )
        ],
        poster: Poster(
          heroTag: widget.ratingKey,
          mediaType: widget.mediaType,
          uri: widget.posterUri,
        ),
        title: widget.title,
        subtitle: widget.subtitle,
        itemDetail: widget.itemDetail,
        tabs: [
          Tab(child: const Text(LocaleKeys.details_title).tr()),
          if (widget.mediaType == MediaType.show)
            Tab(
              child: const Text(LocaleKeys.seasons_title).tr(),
            ),
          if (widget.mediaType == MediaType.artist)
            Tab(
              child: const Text(LocaleKeys.albums_title).tr(),
            ),
          if (widget.mediaType == MediaType.season)
            Tab(
              child: const Text(LocaleKeys.episodes_title).tr(),
            ),
          if (![MediaType.photo, MediaType.photoAlbum].contains(widget.mediaType))
            Tab(child: const Text(LocaleKeys.history_title).tr()),
        ],
        tabChildren: [
          MediaDetailsTab(ratingKey: widget.ratingKey),
          if ([
            MediaType.show,
            MediaType.artist,
            MediaType.season,
          ].contains(widget.mediaType))
            MediaChildrenTab(
              ratingKey: widget.ratingKey,
              mediaType: widget.mediaType,
              parentPosterUri: widget.posterUri,
            ),
          if (![MediaType.photo, MediaType.photoAlbum].contains(widget.mediaType))
            MediaHistoryTab(
              ratingKey: widget.ratingKey,
              mediaType: widget.mediaType,
              posterUri: widget.posterUri,
            ),
        ],
      ),
    );
  }
}
