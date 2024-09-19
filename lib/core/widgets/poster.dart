import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/settings/data/models/custom_header_model.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../types/media_type.dart';
import '../types/playback_state.dart';

class Poster extends StatelessWidget {
  final MediaType? mediaType;
  final Uri? uri;
  final PlaybackState? activityState;
  final Object? heroTag;
  final bool heroEnabled;
  final bool opaqueBackground;

  const Poster({
    super.key,
    required this.mediaType,
    required this.uri,
    this.activityState,
    this.heroTag,
    this.heroEnabled = true,
    this.opaqueBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return HeroMode(
      enabled: true,
      child: Hero(
        tag: heroTag ?? UniqueKey(),
        child: Builder(
          builder: (context) {
            if ([
              MediaType.album,
              MediaType.artist,
              MediaType.track,
              MediaType.playlist,
              MediaType.photo,
              MediaType.photoAlbum,
            ].contains(mediaType)) {
              return _PosterSquare(
                uri: uri,
                activityState: activityState,
                opaqueBackground: opaqueBackground,
              );
            }

            return _PosterRegular(
              uri: uri,
              activityState: activityState,
            );
          },
        ),
      ),
    );
  }
}

class _PosterRegular extends StatelessWidget {
  final Uri? uri;
  final PlaybackState? activityState;

  const _PosterRegular({
    required this.uri,
    this.activityState,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: uri.toString(),
                    httpHeaders: {
                      for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders) headerModel.key: headerModel.value,
                    },
                    placeholder: (context, url) => Image.asset('assets/images/poster_fallback.png', fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/poster_error.png',
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                if (activityState != null && activityState != PlaybackState.playing) _PosterState(activityState: activityState!),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PosterSquare extends StatelessWidget {
  final Uri? uri;
  final PlaybackState? activityState;
  final bool? opaqueBackground;

  const _PosterSquare({
    required this.uri,
    this.activityState,
    this.opaqueBackground,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Stack(
              children: [
                if (opaqueBackground == true) Positioned.fill(child: Container(color: Colors.grey[900])),
                Positioned.fill(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      state as SettingsSuccess;

                      return DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 25,
                            sigmaY: 25,
                            tileMode: TileMode.decal,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: uri.toString(),
                            httpHeaders: {
                              for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders) headerModel.key: headerModel.value,
                            },
                            placeholder: (context, url) => Image.asset('assets/images/cover_fallback.png'),
                            errorWidget: (context, url, error) => Image.asset('assets/images/cover_error.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: uri.toString(),
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders) headerModel.key: headerModel.value,
                        },
                        placeholder: (context, url) => Image.asset('assets/images/cover_fallback.png'),
                        errorWidget: (context, url, error) => Image.asset('assets/images/cover_error.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (activityState != null && activityState != PlaybackState.playing) _PosterState(activityState: activityState!),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PosterState extends StatelessWidget {
  final PlaybackState activityState;
  const _PosterState({
    required this.activityState,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(color: Colors.black54),
          Center(
            child: FaIcon(
              activityState == PlaybackState.paused
                  ? FontAwesomeIcons.circlePause
                  : activityState == PlaybackState.buffering
                      ? FontAwesomeIcons.spinner
                      : activityState == PlaybackState.error
                          ? FontAwesomeIcons.circleExclamation
                          : FontAwesomeIcons.circleQuestion,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
