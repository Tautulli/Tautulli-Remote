import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../bloc/metadata_bloc.dart';

class MediaItemH2 extends StatelessWidget {
  final MediaItem item;

  const MediaItemH2({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool titleEmpty = ((['episode', 'track'].contains(item.mediaType) &&
            isEmpty(item.title)) ||
        (item.mediaType == 'season' && item.mediaIndex == null) ||
        (item.mediaType == 'movie' && item.year == null) ||
        (item.mediaType == 'album' && isEmpty(item.parentTitle)));

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
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
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

    String parentTitle = item.parentTitle;
    String title = item.title;
    int mediaIndex = item.mediaIndex;
    int year = item.year;
    String mediaType = item.mediaType;

    if (metadata != null) {
      parentTitle = metadata.parentTitle;
      title = metadata.title;
      mediaIndex = metadata.mediaIndex;
      year = metadata.year;
      mediaType = metadata.mediaType;
    }

    switch (mediaType) {
      case 'episode':
      case 'track':
        text = title;
        break;
      case 'season':
        text = 'Season $mediaIndex';
        break;
      case 'movie':
        text = year.toString();
        break;
      case 'show':
      case 'artist':
      case 'collection':
      case 'playlist':
        text = '';
        break;
      case 'album':
      case 'photo':
      case 'clip':
        text = parentTitle;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
