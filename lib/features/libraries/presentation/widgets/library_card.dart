import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../domain/entities/library.dart';

enum LibraryType {
  movie,
  show,
  artist,
  photo,
}

class LibraryCard extends StatelessWidget {
  final List<Library> list;
  final String imageUrl;
  final LibraryType libraryType;

  const LibraryCard({
    Key key,
    @required this.list,
    @required this.imageUrl,
    @required this.libraryType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          constraints: BoxConstraints(minHeight: 115),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LibraryCardHeader(libraryType: libraryType),
                      Divider(
                        color: Colors.grey,
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: list.map((library) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                print('tapped');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        library.sectionName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: library.count.toString(),
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        if (libraryType != LibraryType.movie)
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(fontSize: 18),
                                              children: [
                                                TextSpan(
                                                  text: '/',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: library.parentCount
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (libraryType != LibraryType.movie)
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(fontSize: 18),
                                              children: [
                                                TextSpan(
                                                  text: '/',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: library.childCount
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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

class _LibraryCardHeader extends StatelessWidget {
  final LibraryType libraryType;

  const _LibraryCardHeader({
    Key key,
    @required this.libraryType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: WebsafeSvg.asset(
                  AssetMapperHelper().mapLibrarytoPath(libraryType),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _libraryTypeToTitle(libraryType),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  _libraryTypeToCountHeading(libraryType),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _libraryTypeToTitle(LibraryType libraryType) {
  switch (libraryType) {
    case (LibraryType.movie):
      return 'Movie';
    case (LibraryType.show):
      return 'TV Show';
    case (LibraryType.artist):
      return 'Music';
    case (LibraryType.photo):
      return 'Photo';
    default:
      return 'UNKNOWN';
  }
}

String _libraryTypeToCountHeading(LibraryType libraryType) {
  switch (libraryType) {
    case (LibraryType.movie):
      return 'Movies';
    case (LibraryType.show):
      return 'Shows/Seasons/Episodes';
    case (LibraryType.artist):
      return 'Artists/Albums/Tracks';
    case (LibraryType.photo):
      return 'Albums/Photos/Videos';
    default:
      return 'UNKNOWN';
  }
}
