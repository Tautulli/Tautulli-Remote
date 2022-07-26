import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../features/settings/data/models/custom_header_model.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../types/media_type.dart';
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
      height: MediaQuery.of(context).textScaleFactor > 1 ? 100 * MediaQuery.of(context).textScaleFactor : 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          child: Stack(
            children: [
              if (uri != null)
                Positioned.fill(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      state as SettingsSuccess;

                      return CachedNetworkImage(
                        imageUrl: uri.toString(),
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                            headerModel.key: headerModel.value,
                        },
                        imageBuilder: (context, imageProvider) => DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                        placeholder: (context, url) => Image.asset('assets/images/poster_fallback.png'),
                        errorWidget: (context, url, error) => Image.asset('assets/images/poster_fallback.png'),
                      );
                    },
                  ),
                ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 25,
                    sigmaY: 25,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Poster(mediaType: mediaType, uri: uri),
                        const Gap(4),
                        Expanded(child: details),
                      ],
                    ),
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
          ),
        ),
      ),
    );
  }
}
