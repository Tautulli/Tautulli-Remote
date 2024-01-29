import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../features/settings/data/models/custom_header_model.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../types/media_type.dart';
import 'card_with_forced_tint.dart';
import 'poster.dart';

class PosterCard extends StatelessWidget {
  final MediaType? mediaType;
  final Uri? uri;
  final Widget details;
  final Function()? onTap;

  const PosterCard({
    super.key,
    this.mediaType,
    this.uri,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 100 * MediaQuery.of(context).textScaler.scale(1) : 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CardWithForcedTint(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              return Stack(
                children: [
                  if (!state.appSettings.disableImageBackgrounds && uri != null)
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: uri.toString(),
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders) headerModel.key: headerModel.value,
                        },
                        imageBuilder: (context, imageProvider) => DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: ImageFiltered(
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
                        ),
                        placeholder: (context, url) => ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 25,
                            sigmaY: 25,
                            tileMode: TileMode.decal,
                          ),
                          child: Image.asset(
                            'assets/images/poster_fallback.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 25,
                            sigmaY: 25,
                            tileMode: TileMode.decal,
                          ),
                          child: Image.asset(
                            'assets/images/poster_error.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poster(mediaType: mediaType, uri: uri),
                          const Gap(8),
                          Expanded(child: details),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
