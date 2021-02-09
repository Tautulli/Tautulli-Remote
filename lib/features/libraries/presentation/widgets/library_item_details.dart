import 'package:flutter/material.dart';

import '../../domain/entities/library_media.dart';

class LibraryItemDetails extends StatelessWidget {
  final LibraryMedia item;

  const LibraryItemDetails({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        if (item.mediaType != 'artist')
          Text(
            item.year != null ? item.year.toString() : '',
          ),
      ],
    );
  }
}
