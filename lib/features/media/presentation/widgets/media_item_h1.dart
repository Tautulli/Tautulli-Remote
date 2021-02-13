import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../bloc/metadata_bloc.dart';

class MediaItemH1 extends StatelessWidget {
  final MediaItem item;

  const MediaItemH1({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool titleEmpty = ((['episode', 'track'].contains(item.mediaType) &&
            isEmpty(item.grandparentTitle)) ||
        (item.mediaType == 'season' && isEmpty(item.parentTitle)) ||
        (['show', 'movie', 'artist', 'album'].contains(item.mediaType) &&
            isEmpty(item.title)));

    return !titleEmpty && item.mediaType != null
        ? _HeadingText(item: item)
        : BlocBuilder<MetadataBloc, MetadataState>(
            builder: (context, state) {
              if (state is MetadataFailure) {
                return Text('');
              }
              if (state is MetadataSuccess) {
                return _HeadingText(
                  item: item,
                  metadata: state.metadata,
                );
              }
              return SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
          );
  }
}

class _HeadingText extends StatelessWidget {
  final MediaItem item;
  final MetadataItem metadata;

  const _HeadingText({
    @required this.item,
    this.metadata,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = 'UNKNOWN MEDIA TYPE';

    String grandparentTitle = item.grandparentTitle;
    String parentTitle = item.parentTitle;
    String title = item.title;
    String mediaType = item.mediaType;

    if (metadata != null) {
      grandparentTitle = metadata.grandparentTitle;
      parentTitle = metadata.parentTitle;
      title = metadata.title;
      mediaType = metadata.mediaType;
    }

    switch (mediaType) {
      case 'episode':
      case 'track':
        text = grandparentTitle;
        break;
      case 'season':
        text = parentTitle;
        break;
      case 'show':
      case 'movie':
      case 'artist':
      case 'album':
        text = title;
    }

    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: ['movie', 'season', 'show'].contains(mediaType)
            ? 3
            : (mediaType == 'episode' &&
                    item.title != null &&
                    item.title.length > 29)
                ? 1
                : 2,
      ),
    );
  }
}
