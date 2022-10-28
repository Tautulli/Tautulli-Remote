import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/data/models/custom_header_model.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../types/media_type.dart';

class Poster extends StatelessWidget {
  final MediaType? mediaType;
  final Uri? uri;
  final Object? heroTag;
  final bool heroEnabled;

  const Poster({
    super.key,
    required this.mediaType,
    required this.uri,
    this.heroTag,
    this.heroEnabled = true,
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
              return _PosterSquare(uri);
            }

            return _PosterRegular(uri);
          },
        ),
      ),
    );
  }
}

class _PosterRegular extends StatelessWidget {
  final Uri? uri;

  const _PosterRegular(this.uri);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CachedNetworkImage(
              imageUrl: uri.toString(),
              httpHeaders: {
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                  headerModel.key: headerModel.value,
              },
              placeholder: (context, url) => Image.asset(
                'assets/images/poster_fallback.png',
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class _PosterSquare extends StatelessWidget {
  final Uri? uri;

  const _PosterSquare(this.uri);

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
                              for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                                headerModel.key: headerModel.value,
                            },
                            placeholder: (context, url) => Image.asset('assets/images/cover_fallback.png'),
                            errorWidget: (context, url, error) => Image.asset('assets/images/cover_fallback.png'),
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
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                            headerModel.key: headerModel.value,
                        },
                        placeholder: (context, url) => Image.asset('assets/images/cover_fallback.png'),
                        errorWidget: (context, url, error) => Image.asset('assets/images/cover_fallback.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
