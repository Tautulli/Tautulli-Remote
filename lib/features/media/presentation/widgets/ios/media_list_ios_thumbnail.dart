import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';

class MediaListIosThumbnail extends StatelessWidget {
  final String? title;
  final int? mediaIndex;
  final Uri? thumbUri;
  final Function()? onTap;

  const MediaListIosThumbnail({
    super.key,
    this.title,
    this.mediaIndex,
    this.thumbUri,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(12),
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
          ),
        ),
        Container(
          height: mediaIndex != null ? 50 : 28,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              const Gap(4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (mediaIndex != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${LocaleKeys.episode_title.tr()} $mediaIndex',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
