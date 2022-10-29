import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class MediaListThumbnail extends StatelessWidget {
  final String? title;
  final int? mediaIndex;
  final Uri? thumbUri;
  final Function()? onTap;

  const MediaListThumbnail({
    super.key,
    this.title,
    this.mediaIndex,
    this.thumbUri,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                return CachedNetworkImage(
                  imageUrl: thumbUri.toString(),
                  httpHeaders: {
                    for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                      headerModel.key: headerModel.value,
                  },
                  placeholder: (context, url) => Image.asset('assets/images/art_fallback.png', fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Image.asset('assets/images/art_error.png', fit: BoxFit.cover),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          //* Gradient layer to make text visible
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: [
                    0.5,
                    1,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mediaIndex != null)
                    Text(
                      '${LocaleKeys.episode_title.tr()} $mediaIndex',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
      ),
    );
  }
}
