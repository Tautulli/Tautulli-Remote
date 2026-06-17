import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/data/models/custom_header_model.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../helpers/theme_helper.dart';
import '../../types/media_type.dart';
import '../../types/playback_state.dart';
import '../base/image_gradient_background.dart';

class CupertinoStylePoster extends StatelessWidget {
  final MediaType? mediaType;
  final Uri? uri;
  final PlaybackState? activityState;
  final bool opaqueBackground;

  const CupertinoStylePoster({
    super.key,
    required this.mediaType,
    required this.uri,
    this.activityState,
    this.opaqueBackground = false,
  });

  @override
  Widget build(BuildContext context) {
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
    return ClipRSuperellipse(
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
                      for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                        headerModel.key: headerModel.value,
                    },
                    placeholder: (context, url) => Image.asset('assets/images/poster_fallback.png', fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/poster_error.png',
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                if (activityState != null && activityState != PlaybackState.playing)
                  _PosterState(activityState: activityState!),
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
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Stack(
              children: [
                if (opaqueBackground == true)
                  Positioned.fill(child: Container(color: CupertinoColors.systemBackground.darkElevatedColor)),
                Positioned.fill(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      state as SettingsSuccess;

                      return ImageGradientBackground(
                        imageUri: uri,
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                            headerModel.key: headerModel.value,
                        },
                      );
                    },
                  ),
                ),
                Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRSuperellipse(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: uri.toString(),
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                            headerModel.key: headerModel.value,
                        },
                        placeholder: (context, url) => Image.asset('assets/images/cover_fallback.png'),
                        errorWidget: (context, url, error) => Image.asset('assets/images/cover_error.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (activityState != null && activityState != PlaybackState.playing)
                  _PosterState(activityState: activityState!),
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
          Container(color: CupertinoColors.black.withValues(alpha: 0.54)),
          Center(
            child: Icon(
              activityState == PlaybackState.paused
                  ? CupertinoIcons.pause_circle
                  : activityState == PlaybackState.buffering
                  ? CupertinoIcons.slowmo
                  : activityState == PlaybackState.error
                  ? CupertinoIcons.exclamationmark_circle_fill
                  : CupertinoIcons.question_circle_fill,
              size: 48,
              color: ThemeHelper.cupertinoCardIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
